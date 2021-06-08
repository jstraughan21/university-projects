#--------------------------------------------------------------------#
# Name:     facial_recognition_LBPH.py
# Author:   Senior Design Group
# Date:     4/13/2021
#--------------------------------------------------------------------#

from PIL import Image
import cv2
import io
import mysql.connector
import numpy
import sys
import time
import RPi.GPIO as GPIO


def connect_to_database():
    """
    connect_to_database will establish a connection and grab all of the info.
    If a connection cannot be established, the program will exit.
    :return: retrievalPacket is all the information in the database.
    """
    # Try to connect to the database
    try:
        mydb = mysql.connector.connect(
            host="192.168.1.8",
            user="root",
            passwd="password",
            database="facial_recog_database"
        )
        print("[INFO] Successfully connected to the database...")
    except:
        print("[ERROR] Could not connect to the database. Check network connection...")
        print("[ERROR] Exiting Program...")
        sys.exit(1)

    # Create a cursor to navigate the database
    cursor = mydb.cursor()
    cursor.execute("SELECT * FROM facial_recog_database.student")

    # Retrieve all information from the database
    retrievalPacket = cursor.fetchall()

    # Clean up connections
    cursor.close()
    mydb.close()

    return retrievalPacket


def get_database_information(haarCascade, retrievalPacket):
    """
    get_database_information will sort IDs, studentIDs, accessStatus, and photos.
    :param1: haarCascade is the .xml file used for classification.
    :param2: retrievalPacket is the packet of information from the database.
    :return: facialData, IDs, studentIDs, and accessStatus.
    """

    # Instantiate 4 arrays to hold the information
    facialData = []
    IDs = []
    studentsIDs = []
    accessStatus = []

    # For each person in the database, get their information
    for column in retrievalPacket:
        stream = io.BytesIO(column[3])
        imagePIL = Image.open(stream).convert("L")
        imageNumpy = numpy.array(imagePIL, 'uint8')
        faces = haarCascade.detectMultiScale(imageNumpy,
                                             scaleFactor=1.1,
                                             minNeighbors=8,
                                             minSize=(30, 30))
        for (x, y, w, h) in faces:
            facialData.append(imageNumpy[y:y+h, x:x+w])
            IDs.append(column[0])
            studentsIDs.append(column[1])
            accessStatus.append(column[2])

    # Print update to the console
    print("[INFO] Information retreived from database...")

    return facialData, IDs, studentsIDs, accessStatus


def train_dataset(recognizer, facialData, IDs):
    """
    train_dataset will train the LBPH algorithm to each image in the dataset
    :param1: recognizer is the LBPH recognizer object
    :param2: facialData is the list of facial fata
    :param3: IDs is the list of associated IDs
    """

    # Print update to the console
    print("[INFO] Training faces. Please wait it will take a few seconds...")

    # Train LBPH algorithm
    recognizer.train(facialData, numpy.array(IDs))
    recognizer.write(trainerPath)

    # Print update to the console
    print("[INFO] Finished Training. {} faces trained...".format(
        len(numpy.unique(IDs))))


if __name__ == "__main__":

    print("\n--------------------")

    # Path to the Haar Cascade and the trainer file
    haarCascadePath = r"/home/seniordesign/opencv/data/haarcascades_cuda/haarcascade_frontalface_default.xml"
    trainerPath = r"/home/seniordesign/Desktop/recognition/trainer/trainer.yml"

    # Haar cascade and LBPH algorithm setup
    haarCascade = cv2.CascadeClassifier(haarCascadePath)
    recognizer = cv2.face.LBPHFaceRecognizer_create()

    # Get the data from the database
    retrievalPacket = connect_to_database()

    # Find how many entries there are in the database
    lastNumStudents = len(retrievalPacket)

    # Get the time this information was pulled
    lastPull = time.time()

    # From the retrievalPacket, separate the fields
    facialData, IDs, studentsIDs, accessStatus = get_database_information(
        haarCascade, retrievalPacket)

    # Train the algorithm
    train_dataset(recognizer, facialData, IDs)

    # Initialize the RPi camera stream
    captureWidth = 1280
    captureHeight = 720
    displayWidth = 1280
    displayHeight = 720
    framerate = 60
    flip_method = 2
    cam = cv2.VideoCapture("nvarguscamerasrc ! "
                           "video/x-raw(memory:NVMM), "
                           "width=(int)%d, "
                           "height=(int)%d, "
                           "format=(string)NV12, "
                           "framerate=(fraction)%d/1 ! "
                           "nvvidconv flip-method=%d ! "
                           "video/x-raw, "
                           "width=(int)%d, "
                           "height=(int)%d, "
                           "format=(string)BGRx ! "
                           "videoconvert ! "
                           "video/x-raw, "
                           "format=(string)BGR ! "
                           "appsink"
                           % (
                               captureWidth,
                               captureHeight,
                               framerate,
                               flip_method,
                               displayWidth,
                               displayHeight
                           ), cv2.CAP_GSTREAMER)
    time.sleep(2.0)

    # GPIO setup for the door actuation circuit (Pin 18 -> Pin 12)
    outputPin = 18
    GPIO.setmode(GPIO.BCM)
    GPIO.setup(outputPin, GPIO.OUT, initial=GPIO.LOW)

    # Verify the camera was successfully initialized
    if cam.isOpened() == True:
        print("[INFO] Camera successfully opened...")

        # Read the trainer file
        recognizer.read(trainerPath)

        # Font for display:
        font = cv2.FONT_HERSHEY_COMPLEX

        # For the smoothest display, skip 6 frames
        count = 0
        framesToSkip = 6

        while True:
            # Record the current time
            currentTime = time.time()

            # Read a video frame
            _ret, image = cam.read()

            # Have we skipped 6 frames?
            if count < framesToSkip:
                count = count + 1

            else:
                # Convert the frame to grayscale and find the faces
                imageGray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
                faces = haarCascade.detectMultiScale(imageGray,
                                                     scaleFactor=1.1,
                                                     minNeighbors=20,
                                                     minSize=(40, 40))

                # Set the output pin low
                GPIO.output(outputPin, GPIO.LOW)

                # For each face detected, decide if they are known
                for(x, y, w, h) in faces:

                    # Decide who the person is
                    ID, confidence = recognizer.predict(
                        imageGray[y:y+h, x:x+w])

                    # Draw either a green or red box (BGR) and toggle the GPIO pin
                    if (confidence < 55):
                        if (accessStatus[ID] == "True"):
                            nameOfPerson = studentsIDs[ID]
                            GPIO.output(outputPin, GPIO.HIGH)
                            cv2.rectangle(image, (x, y), (x+w, y+h),
                                          (0, 255, 0), 2)
                        else:
                            nameOfPerson = studentsIDs[ID]
                            GPIO.output(outputPin, GPIO.LOW)
                            cv2.rectangle(image, (x, y), (x+w, y+h),
                                          (0, 0, 225), 2)
                    else:
                        nameOfPerson = "Unknown"
                        GPIO.output(outputPin, GPIO.LOW)
                        cv2.rectangle(image, (x, y), (x+w, y+h),
                                      (0, 0, 255), 2)

                    # Display the name and confidence level
                    cv2.putText(image, str(nameOfPerson), (x+5, y-5),
                                font, 1, (255, 255, 255), 2)
                    cv2.putText(image, str(round(confidence, 2)), (x+5, y+h-5),
                                font, 1, (255, 255, 0), 1)

                # Reset the frame counter
                count = 0

                # Show the frame
                cv2.imshow("CameraFeed", image)

            # Check if a certain amount of time has passed
            if (currentTime - lastPull >= 10):

                # Get the time
                lastPull = time.time()

                # Get data
                retrievalPacket = connect_to_database()

                # Find how many entries there are in the database
                numStudents = len(retrievalPacket)

                print("---------")
                print("New: " + str(numStudents))
                print("Old: " + str(lastNumStudents))
                print("---------")

                # Are there more entries than last time?
                if (numStudents != lastNumStudents):

                    # Print update to the console
                    print("Updating training data")

                    # Display something to let the user know it's updating
                    cv2.rectangle(image, (0, 0), (displayWidth,
                                                  displayHeight), (255, 0, 0), -1)
                    cv2.putText(image, "Updating Database", (100, 100),
                                font, 1, (255, 255, 0), 1)
                    cv2.imshow("CameraFeed", image)

                    # Find how many entries there are in the database
                    lastNumStudents = len(retrievalPacket)

                    # From the packet, separate the fields
                    facialData, IDs, studentsIDs, accessStatus = get_database_information(
                        haarCascade, retrievalPacket)

                    # Train the algorithm
                    train_dataset(recognizer, facialData, IDs)

            # If the user presses `ESC` break the loop
            k = cv2.waitKey(1) & 0xff
            if k == 27:
                break

    else:
        print("[ERROR] Camera failed to open....")

    # Print update to the console
    print("[INFO] Exiting Program...")

    # Cleanup all connections
    cam.release()
    cv2.destroyAllWindows()
    GPIO.cleanup()

    print("--------------------\n")
