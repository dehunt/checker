# Checker baseline tests
# python 3.7.2
import sys, os, shutil, subprocess, filecmp, platform
devnull = open(os.devnull, 'w')

#skipLines is how many lines of the output file need to be skipped. This should cover the timestamp, JSON path, and input doc path
skipLines=6

# Expected format: test_pdf
def runTest(testFile, testVars = None):
    # print("Running test: ", testFile)
    if os.path.isfile(os.path.join(inDir, testFile+".pdf")) == False:
        print("Test file not found: %s.pdf" % testFile)
        sys.exit()
    try:
        if testVars is None:
            subprocess.run(exeDir+" --input "+os.path.join(inDir, testFile+".pdf")+" --output "+os.path.join(outDir, testFile+".txt")+" --profile "+ os.path.join(inDir, testJson), shell=True, stdout=devnull)
        else:
            subprocess.run(exeDir+" --input "+os.path.join(inDir, testFile+".pdf")+" --output "+os.path.join(outDir, testFile+".txt")+" --profile "+ os.path.join(inDir, testJson) + " " + testVars, shell=True, stdout=devnull)
    except:
        print("Failed to run test: %s" % testFile)

def verifyResults(testName):
    # print("Verifying test: ", testName)
    try:
        testFile = os.path.join(outDir, testName+".txt")
        if os.path.isfile(testFile) == False:
            print("Output file not found: %s" % testFile)
            sys.exit()
        baseFile = os.path.join(baseDir, testName+".txt")
        if os.path.isfile(baseFile) == False:
            print("Baseline file not found: %s" % baseFile)
            sys.exit()
        # Get the output and baseline file data without the timestamp, JSON path, and input doc path
        with open(testFile, 'rt') as testOutput:
            testContents = testOutput.readlines()
            testContents = testContents[skipLines:]
        with open(baseFile, 'rt') as baseOutput:
            baseContents = baseOutput.readlines()
            baseContents = baseContents[skipLines:]
        if testContents == baseContents:
            print('Test {:40}:  Passed'.format(testName))
        else:
            print('Test {:40}:  Failed'.format(testName))
    except:
        print("Failed to verify test: %s" %testName)

def printUsage():
    print("Usage:", sys.argv[0], "<Checker-installation-directory> <test-pdf-directory> <output-file-directory> <baseline-file-directory>")

# Check arguments - use for number of arguments: len(sys.argv)

numArg = len(sys.argv)
if numArg < 5 or numArg > 5:
    print("Error: Incorrect number of arguments")
    printUsage()
    sys.exit()
else:
    exeDir = sys.argv[1]
    inDir = sys.argv[2]
    outDir = sys.argv[3]
    baseDir = sys.argv[4]

print("Test file directory:   ", inDir)
print("Output file directory: ", outDir)

# Check exe dir
if os.path.isdir(exeDir) == False:
    print("Exe directory not found at:", exeDir)
    sys.exit()

# Verify everything.json
testJson = os.path.join(exeDir, "CheckerProfiles", "everything.json")
if os.path.isfile(testJson) == False:
    print("Json file not found at:", testJson)
    sys.exit()

# Sort by OS
osType = platform.system()
# osType = os.name
# if osType == "nt":
    # exeDir = os.path.join(exeDir, "Checker.exe")
# elif osType == "posix":
    # exeDir = os.path.join(exeDir, "Checker")
if osType == "Windows":
    exeDir = os.path.join(exeDir, "Checker.exe")
elif osType == "Linux":
    exeDir = os.path.join(exeDir, "Checker")
else:
    print("Unsupported OS Type")
    sys.exit()

# Verify exe path
if os.path.isfile(exeDir) == False:
    print("Exe file not found at:", exeDir)
    sys.exit()

# Check input file directory
if os.path.isdir(inDir) == False:
    print("Input file directory not found at:", inDir)
    sys.exit()

# Check output file directory, clean if found, create if needed
if os.path.isdir(outDir) == True:
    print("Output directory found. Cleaning output directory...")
    counter = 0
    for root, dirs, files in os.walk(outDir):
        for file in files:
            if not file.endswith(".txt"):
                counter += 1
    if counter > 0:
        print("Non txt files found at output directory. Exiting without cleaning.")
        sys.exit()
    else:
        shutil.rmtree(outDir)
        os.mkdir(outDir)
else:
    print("Creating output directory...")
    try:
        os.mkdir(outDir)
    except OSError:
        print ("Creation of output directory failed")
    else:
        print ("Created output directory at:", outDir)

print("-------------------------------------")
print("Executing Checker Baseline Tests")
print("-------------------------------------")
print("Exe directory:         ", exeDir)
print("Test file directory:   ", inDir)
print("Output file directory: ", outDir)

testCases = [
    '414-instructions','414-instructions_A-1a','corrupt-metadata','AddAttachments','AddLinks',
    'Annotations','AnnotsNotForViewingAndPrinting','brokenpdf','configom','CreateAnnotations',
    'dsd_a112','essent-voorschotten','extractFrom','FindImageResolutions',
    'hello-broken_1','JavaScriptClock','LocallyBuiltSample','Matrix2DOperationsJavascriptOperations',
    'OwnerPassword','PDF_2.0_with_page_level_output_intent','PDFannotationtestfile-noappearances',
    'PDFannotationtestfile-withappearances','Signed_Gibson_PKCS7_DETACHED_Sha256','SimplePDF2.0file',
    'Test_contains_private_data','TheFlyv3_EN4Rdr','TheWarOfTheWorlds','PDFCHECK-34','PDFCHECK-34a',
    'DocWithManyImagesAndStreamsAndFonts','brokenpdf','Encrypted','OwnerPassword','Verdana-Unembedded',
    'AdditionalChecksDamagedFiles']

for test in testCases:
    runTest(test)
    verifyResults(test)

runTest("AddPassword", "-p Datalogics")
verifyResults("AddPassword")
runTest("AddWatermark", "-p Datalogics")
verifyResults("AddWatermark")
runTest("EncryptDocument", "-p myPass")
verifyResults("EncryptDocument")

