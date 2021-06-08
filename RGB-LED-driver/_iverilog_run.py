#-------------------------------------------------------------------#
#   This script is intended to compile and show the wavedata using
# iVerilog and gtkwave. It takes in the names of each file from the
# console and runs the proper commands to test the Verilog files.
#
#   --> Make sure the iVerilog and gtkwave binaries are in the system
#       path
#   --> Run this script from the project directory
#
#-------------------------------------------------------------------#

# Import the necessary modules
import subprocess

# Determine if this is a top level module being tested
topLevel = input("Is this a top-level module? (y/n): ")

if topLevel.lower() == "y":

    # User specifies how many source files are needed for compilation
    numSrc = int(input("Enter the number of sources: "))

    # Create a list filled with the names of each source file
    srcList = []
    for i in range(numSrc):
        srcList.append(input("Enter the name of source {}: ".format(i+1)))

    # Create a string out of the list of names
    srcString = ""
    for src in srcList:
        srcString = srcString + src + " "

    # User specifies the testbench
    testString = input("Enter the name of the test bench: ")

else:
    # User specifies the source file
    srcString = input("Enter the name of the source: ") + " "

    # User specifies the testbench
    testString = input("Enter the name of the test bench: ")

# Run the proper commands
subprocess.run("iverilog {}{}".format(srcString, testString))
subprocess.run("vvp a.out")
subprocess.run("gtkwave wavedata.vcd")
