import std/strutils

proc processLine(line: string, oldWord: string, newWord: string): string =
    # Replace the specific word in the line
    var modifiedLine = line.replace(oldWord, newWord)

    # Find the position of "=" in the line
    let equalPos = modifiedLine.find('=')

    # If "=" is found, cut the line up to the position of "="
    if equalPos != -1:
        modifiedLine = modifiedLine[0 ..< equalPos]

    return modifiedLine

# Function to process the entire file line by line
proc replaceWordAndCutAfterEqual(inputFile: string, outputFile: string, oldWord: string, newWord: string) =
    # Open input file for reading
    var inputFileHandle = open(inputFile, fmRead)
    # Open output file for appending
    var outputFileHandle = open(outputFile, fmAppend)

    # Iterate over each line in the input file
    for line in inputFileHandle.lines:
        # Process each line to replace the word and cut after "="
        let modifiedLine = processLine(line, oldWord, newWord)
        # Write the modified line to the output file
        outputFileHandle.writeLine(modifiedLine)

    # Close the files
    inputFileHandle.close()
    outputFileHandle.close()

# Main block
let inputFileName = "/home/spcstunnel/env"
let outputFileName = "/etc/bash.bashrc"
let wordToReplace = "export"
let replacementWord = "unset"

# Call the function to process the file
replaceWordAndCutAfterEqual(inputFileName, outputFileName, wordToReplace, replacementWord)

echo "Unsetting variables "

