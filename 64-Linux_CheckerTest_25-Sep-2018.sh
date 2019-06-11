# Checker baseline tests
# 21 Mar 2018

# Results are currently checked by searching for specific text strings in the output files.
# Comparing the output files to known good files is not valid without parsing the output text, because the version and timestamp will vary between tests.
# The string to compare against should be stored in a better way, and/or externalized

testDir=
exeDir=
outDir=
#compDir=
jsonDir=

[ -d $outDir ] || mkdir -p $outDir

echo "-----------------------------------"
echo "Executing Checker Baseline Tests"
echo "-----------------------------------"
echo
echo "Test File Directory:       "$testDir
echo "Checker Directory:      "$exeDir
echo "Output Directory:          "$outDir
#echo "Comparison File Directory: "$compDir
echo "json Profile Directory:    "$jsonDir
echo 

runTest () {
	# echo $1
	# echo $2
	echo "Running test: "$1
	$exeDir"checker" -i $testDir$2 -j $jsonDir -o $outDir$1".txt" $3
}

checkResults () {
	echo "Checking "$1" results..."
	outFile=$1".txt"
#	echo $2
#	echo $3 
#	echo $4

	outString=$(awk "/$2/{flag=1;next}/$3/{flag=0}flag" $outDir$outFile)
#	echo "$outString"

	if [ "$outString" == "$4" ]; then
		printf '%-58s Passed\n' "Test $1:"
	else
		printf '%-58s FAILED\n' "Test $1:"
	fi
}

# fileComp () {
	# echo "Comparing "$1" with known file..."
	# if cmp -s $compDir$1".txt" $outDir$1".txt"; then
		# printf '%-50s Passed\n' "File Comparison $1:"
	# else
		# printf '%-50s FAILED\n' "File Comparison $1:"
	# fi
	# echo
# }

echo

# Userdata, Fonts, Image - Color, Grayscale
runTest 414instructions 414-instructions.pdf 
checkResults 414instructions "Userdata Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains annotations: 
            SubType: Link (24 instances)
        Contains transparency: 
            Total: (5 instances)"
checkResults 414instructions "Fonts Results" "Checks Completed" "    Errors:
        Uses Base 14 fonts not embedded in document: 
            Arial (1 instance)
            Times New Roman (1 instance)
            Times New Roman,Bold (1 instance)
            Times New Roman,BoldItalic (1 instance)
            Times New Roman,Italic (1 instance)
    Information:
        Uses fonts fully embedded in document: 
            Symbol (1 instance)
            Times New Roman (1 instance)
            Times New Roman,Bold (1 instance)"
checkResults 414instructions "Grayscale Images" "Monochrome Images" "    Errors:
        None
    Information:
        Low resolution gray image(s) present: 
            Total: (2 instances)
    Checks Completed:
        resolution-too-high
        resolution-too-low
        uses-jpeg2000-compression"
checkResults 414instructions "Monochrome Images" "uses-jbig2-compression" "    Errors:
        None
    Information:
        None
    Checks Completed:
        resolution-too-high
        resolution-too-low"
echo

# Userdata, Cleanup, Image - Color Images
runTest 414instructions-a 414-instructions_A-1a.pdf 
checkResults 414instructions-a "Userdata Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains annotations: 
            SubType: Link (24 instances)
        Contains metadata: 
            SubType: XML, Update region size: 2048 (1 instance)"
checkResults 414instructions-a "Cleanup Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains conservatively compressed streams: 
            Uncompressed: (2 instances)"
checkResults 414instructions-a "Color Images" "Checks Completed" "    Errors:
        None
    Information:
        Low resolution color image(s) present: 
            Total: (4 instances)"
echo

# Userdata, Cleanup, Image - Color Images
runTest corruptMetadata	2013-14_Student_Handbook_with_corrupt_metadata.pdf
checkResults corruptMetadata "Userdata Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains metadata: 
            SubType: XML, Malformed Object (1 instance)
            SubType: XML, Update region size: 0 (6 instances)
            SubType: XML, Update region size: 2048 (1 instance)
        Contains transparency: 
            Total: (58 instances)"
checkResults corruptMetadata "Cleanup Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains conservatively compressed streams: 
            Uncompressed: (1 instance)"
checkResults corruptMetadata "Color Images" "Checks Completed" "    Errors:
        None
    Information:
        Color image(s) using JPEG2000 compression: 
            Total: (2 instances)"
echo

# Userdata, Cleanup
runTest addAttachments AddAttachments.pdf
checkResults addAttachments "Userdata Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains annotations: 
            SubType: FileAttachment (1 instance)
        Contains annotations that are set as invisible for printing: 
            SubType: FileAttachment (1 instance)
        Contains embedded files: 
            Total: (2 instances)
        Contains metadata: 
            SubType: XML, Update region size: 2048 (1 instance)"
checkResults addAttachments "Cleanup Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains conservatively compressed streams: 
            Uncompressed: (2 instances)"
echo

# Userdata, Fonts
runTest addLinks AddLinks.pdf
checkResults addLinks "Userdata Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains annotations: 
            SubType: Link (3 instances)
        Contains annotations that are set as invisible for printing: 
            SubType: Link (3 instances)
        Contains metadata: 
            SubType: XML, Update region size: 2048 (1 instance)"
checkResults addLinks "Fonts Results" "Checks Completed" "    Errors:
        Uses Base 14 fonts not embedded in document: 
            Times New Roman (1 instance)
    Information:
        Uses fonts fully embedded in document: 
            CourierStd (3 instances)"
echo

# General, Userdata, Fonts, Image - Color, Grayscale
runTest addPassword AddPassword.pdf "-p Datalogics"
checkResults addPassword "General Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains owner password"
checkResults addPassword "Userdata Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains annotations: 
            SubType: Widget (16 instances)
        Contains annotations that are set as invisible for printing: 
            SubType: Widget (1 instance)
        Contains annotations that are set as invisible for viewing: 
            SubType: Widget (1 instance)
        Contains embedded files: 
            Total: (1 instance)
        Contains metadata: 
            SubType: XML, Update region size: 2048 (1 instance)
        Contains transparency: 
            Total: (1 instance)"
checkResults addPassword "Fonts Results" "Checks Completed" "    Errors:
        Uses Base 14 fonts not embedded in document: 
            Arial-BoldMT (1 instance)
            ArialMT (1 instance)
    Information:
        None"
checkResults addPassword "Grayscale Images" "Checks Completed" "    Errors:
        None
    Information:
        Low resolution gray image(s) present: 
            Total: (1 instance)"
echo

# Userdata, Fonts, Cleanup, Image - Color
runTest addWatermark AddWatermark.pdf "-p Datalogics"
checkResults addWatermark "Userdata Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains metadata: 
            SubType: XML, Update region size: 2048 (1 instance)
        Contains optional content (layers)
        Contains transparency: 
            Total: (3 instances)"
checkResults addWatermark "Fonts Results" "Checks Completed" "    Errors:
        Uses fonts not embedded in document: 
            CourierStd (1 instance)
    Information:
        None"
checkResults addWatermark "Cleanup Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains conservatively compressed streams: 
            Uncompressed: (4 instances)"
checkResults addWatermark "Color Images" "Checks Completed" "    Errors:
        None
    Information:
        Low resolution color image(s) present: 
            Total: (1 instance)"
echo 

# Userdata
runTest annotations Annotations.pdf
checkResults annotations "Userdata Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains annotations: 
            SubType: Highlight (30 instances)
            SubType: Link (5 instances)
            SubType: Popup (1 instance)
            SubType: Text (40 instances)
        Contains annotations that are set as invisible for printing: 
            SubType: Highlight (30 instances)
            SubType: Link (5 instances)
            SubType: Popup (1 instance)
            SubType: Text (40 instances)
        Contains embedded files: 
            Total: (1 instance)
        Contains metadata: 
            SubType: XML, Update region size: 0 (1 instance)
            SubType: XML, Update region size: 2048 (1 instance)"
echo

# Userdata, Fonts, Cleanup
runTest annotsNotForViewingAndPrinting AnnotsNotForViewingAndPrinting.pdf
checkResults annotsNotForViewingAndPrinting "Userdata Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains annotations: 
            SubType: Circle (1 instance)
            SubType: FreeText (2 instances)
            SubType: Highlight (1 instance)
            SubType: Ink (1 instance)
            SubType: Line (2 instances)
            SubType: Polygon (2 instances)
            SubType: Popup (11 instances)
            SubType: Square (1 instance)
            SubType: Stamp (1 instance)
            SubType: StrikeOut (1 instance)
            SubType: Underline (1 instance)
        Contains annotations that are set as invisible for printing: 
            SubType: Popup (1 instance)
        Contains annotations that are set as invisible for viewing: 
            SubType: Square (1 instance)
        Contains embedded files: 
            Total: (1 instance)
        Contains metadata: 
            SubType: XML, Update region size: 2048 (1 instance)
        Contains transparency: 
            Total: (1 instance)"
checkResults annotsNotForViewingAndPrinting "Fonts Results" "Checks Completed" "    Errors:
        Uses Base 14 fonts not embedded in document: 
            Helvetica (1 instance)
            Helvetica-BoldOblique (1 instance)
    Information:
        None"
checkResults annotsNotForViewingAndPrinting "Cleanup Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains conservatively compressed streams: 
            Uncompressed: (4 instances)"
echo

# General
runTest brokenpdf brokenpdf.pdf
checkResults brokenpdf "General Results" "Checks Aborted" "    Errors:
        Damaged document
        Cannot be opened/not valid PDF
    Information:
        None
    Checks Completed:
        damaged
        unable-to-open (triggered abort)"
echo

# Userdata, Fonts, Cleanup
runTest configom configom.pdf
checkResults configom "Userdata Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains annotations: 
            SubType: Link (96 instances)
        Contains annotations that are set as invisible for printing: 
            SubType: Link (96 instances)
        Contains embedded files: 
            Total: (1 instance)"
checkResults configom "Fonts Results" "Checks Completed" "    Errors:
        None
    Information:
        Uses fonts fully embedded in document: 
            Courier (1 instance)
            Frutiger-Black (1 instance)
            Frutiger-BlackItalic (1 instance)
            Frutiger-Light (1 instance)
            Frutiger-Roman (1 instance)
            Helvetica-Black (1 instance)
            Sabon-Italic (1 instance)
            Sabon-Roman (1 instance)
            Symbol (1 instance)"
checkResults configom "Cleanup Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains conservatively compressed streams: 
            Uncompressed: (9 instances)"
echo

# Userdata, Fonts
runTest createAnnotations CreateAnnotations.pdf
checkResults createAnnotations "Userdata Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains annotations: 
            SubType: Highlight (71 instances)
            SubType: Link (4 instances)
            SubType: Text (45 instances)
        Contains annotations that are set as invisible for printing: 
            SubType: Highlight (71 instances)
            SubType: Link (4 instances)
            SubType: Text (45 instances)
        Contains embedded files: 
            Total: (1 instance)
        Contains metadata: 
            SubType: XML, Update region size: 0 (1 instance)
            SubType: XML, Update region size: 2048 (1 instance)"
checkResults createAnnotations "Fonts Results" "Checks Completed" "    Errors:
        Uses Base 14 fonts not embedded in document: 
            Arial-BoldMT (1 instance)
            Arial-ItalicMT (1 instance)
            ArialMT (1 instance)
    Information:
        None"
echo

# Userdata, Cleanup, Image - Color, Grayscale, Monochrome
runTest dsd_a112 dsd_a112.pdf
checkResults dsd_a112 "Userdata Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains metadata: 
            SubType: XML, Update region size: 2048 (1 instance)
        Contains transparency: 
            Total: (1 instance)"
checkResults dsd_a112 "Cleanup Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains conservatively compressed streams: 
            Uncompressed: (5 instances)"
checkResults dsd_a112 "Color Images" "Checks Completed" "    Errors:
        None
    Information:
        Low resolution color image(s) present: 
            Total: (8 instances)"
checkResults dsd_a112 "Grayscale Images" "Checks Completed" "    Errors:
        None
    Information:
        Low resolution gray image(s) present: 
            Total: (2 instances)"
checkResults dsd_a112 "Monochrome Images" "Checks Completed" "    Errors:
        None
    Information:
        Low resolution monochrome image(s) present: 
            Total: (1 instance)"
echo

# General
runTest encryptDoc EncryptDocument.pdf
checkResults encryptDoc "General Results" "Checks Aborted" "    Errors:
        Requires password for opening
        Cannot be opened/not valid PDF
    Information:
        None
    Checks Completed:
        password-protected (triggered abort)
        unable-to-open (triggered abort)"
echo

# General, Userdata
runTest encryptDocWPass EncryptDocument.pdf "-p myPass"
checkResults encryptDocWPass "General Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains owner password"
checkResults encryptDocWPass "Userdata Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains metadata: 
            SubType: XML, Update region size: 2048 (1 instance)"
echo

# Userdata, Fonts, Cleanup
runTest essent-voorschotten essent-voorschotten.pdf
checkResults essent-voorschotten "Userdata Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains metadata: 
            SubType: XML, Update region size: 2049 (1 instance)"
checkResults essent-voorschotten "Fonts Results" "Checks Completed" "    Errors:
        Uses fonts not embedded in document: 
            F10 (1 instance)
            F101 (1 instance)
            F102 (1 instance)
            F103 (1 instance)
            F104 (1 instance)
            F105 (1 instance)
            F106 (1 instance)
            F107 (1 instance)
            F108 (1 instance)
            F109 (1 instance)
            F11 (1 instance)
            F110 (1 instance)
            F113 (1 instance)
            F114 (1 instance)
            F117 (1 instance)
            F118 (1 instance)
            F12 (1 instance)
            F120 (1 instance)
            F121 (1 instance)
            F123 (1 instance)
            F124 (1 instance)
            F125 (1 instance)
            F126 (1 instance)
            F128 (1 instance)
            F129 (1 instance)
            F13 (1 instance)
            F130 (1 instance)
            F131 (1 instance)
            F132 (1 instance)
            F134 (1 instance)
            F135 (1 instance)
            F136 (1 instance)
            F137 (1 instance)
            F14 (1 instance)
            F140 (1 instance)
            F143 (1 instance)
            F144 (1 instance)
            F145 (1 instance)
            F146 (1 instance)
            F147 (1 instance)
            F148 (1 instance)
            F149 (1 instance)
            F15 (1 instance)
            F152 (1 instance)
            F153 (1 instance)
            F154 (1 instance)
            F155 (1 instance)
            F156 (1 instance)
            F157 (1 instance)
            F158 (1 instance)
            F159 (1 instance)
            F16 (1 instance)
            F160 (1 instance)
            F161 (1 instance)
            F162 (1 instance)
            F163 (1 instance)
            F164 (1 instance)
            F165 (1 instance)
            F166 (1 instance)
            F167 (1 instance)
            F168 (1 instance)
            F169 (1 instance)
            F17 (1 instance)
            F170 (1 instance)
            F171 (1 instance)
            F172 (1 instance)
            F174 (1 instance)
            F175 (1 instance)
            F176 (1 instance)
            F177 (1 instance)
            F178 (1 instance)
            F179 (1 instance)
            F18 (1 instance)
            F180 (1 instance)
            F182 (1 instance)
            F184 (1 instance)
            F185 (1 instance)
            F187 (1 instance)
            F188 (1 instance)
            F189 (1 instance)
            F19 (1 instance)
            F190 (1 instance)
            F191 (1 instance)
            F192 (1 instance)
            F194 (1 instance)
            F195 (1 instance)
            F198 (1 instance)
            F2 (1 instance)
            F20 (1 instance)
            F200 (1 instance)
            F201 (1 instance)
            F202 (1 instance)
            F203 (1 instance)
            F206 (1 instance)
            F208 (1 instance)
            F209 (1 instance)
            F21 (1 instance)
            F210 (1 instance)
            F211 (1 instance)
            F212 (1 instance)
            F213 (1 instance)
            F214 (1 instance)
            F215 (1 instance)
            F216 (1 instance)
            F217 (1 instance)
            F218 (1 instance)
            F219 (1 instance)
            F22 (1 instance)
            F221 (1 instance)
            F224 (1 instance)
            F227 (1 instance)
            F228 (1 instance)
            F229 (1 instance)
            F23 (1 instance)
            F230 (1 instance)
            F231 (1 instance)
            F232 (1 instance)
            F233 (1 instance)
            F234 (1 instance)
            F235 (1 instance)
            F236 (1 instance)
            F238 (1 instance)
            F239 (1 instance)
            F24 (1 instance)
            F240 (1 instance)
            F242 (1 instance)
            F243 (1 instance)
            F244 (1 instance)
            F245 (1 instance)
            F246 (1 instance)
            F247 (1 instance)
            F248 (1 instance)
            F25 (1 instance)
            F250 (1 instance)
            F253 (1 instance)
            F254 (1 instance)
            F256 (1 instance)
            F257 (1 instance)
            F258 (1 instance)
            F259 (1 instance)
            F26 (1 instance)
            F260 (1 instance)
            F261 (1 instance)
            F262 (1 instance)
            F263 (1 instance)
            F264 (1 instance)
            F265 (1 instance)
            F266 (1 instance)
            F267 (1 instance)
            F268 (1 instance)
            F269 (1 instance)
            F27 (1 instance)
            F270 (1 instance)
            F271 (1 instance)
            F272 (1 instance)
            F273 (1 instance)
            F274 (1 instance)
            F275 (1 instance)
            F276 (1 instance)
            F278 (1 instance)
            F279 (1 instance)
            F28 (1 instance)
            F281 (1 instance)
            F282 (1 instance)
            F283 (1 instance)
            F284 (1 instance)
            F287 (1 instance)
            F289 (1 instance)
            F29 (1 instance)
            F290 (1 instance)
            F292 (1 instance)
            F295 (1 instance)
            F296 (1 instance)
            F298 (1 instance)
            F299 (1 instance)
            F3 (1 instance)
            F30 (1 instance)
            F300 (1 instance)
            F301 (1 instance)
            F302 (1 instance)
            F304 (1 instance)
            F305 (1 instance)
            F309 (1 instance)
            F31 (1 instance)
            F311 (1 instance)
            F317 (1 instance)
            F318 (1 instance)
            F319 (1 instance)
            F32 (1 instance)
            F320 (1 instance)
            F321 (1 instance)
            F322 (1 instance)
            F323 (1 instance)
            F325 (1 instance)
            F328 (1 instance)
            F329 (1 instance)
            F33 (1 instance)
            F332 (1 instance)
            F333 (1 instance)
            F335 (1 instance)
            F336 (1 instance)
            F337 (1 instance)
            F34 (1 instance)
            F340 (1 instance)
            F341 (1 instance)
            F342 (1 instance)
            F343 (1 instance)
            F345 (1 instance)
            F346 (1 instance)
            F35 (1 instance)
            F350 (1 instance)
            F351 (1 instance)
            F356 (1 instance)
            F358 (1 instance)
            F36 (1 instance)
            F360 (1 instance)
            F361 (1 instance)
            F363 (1 instance)
            F364 (1 instance)
            F365 (1 instance)
            F367 (1 instance)
            F369 (1 instance)
            F37 (1 instance)
            F370 (1 instance)
            F372 (1 instance)
            F373 (1 instance)
            F374 (1 instance)
            F375 (1 instance)
            F376 (1 instance)
            F377 (1 instance)
            F379 (1 instance)
            F382 (1 instance)
            F383 (1 instance)
            F384 (1 instance)
            F385 (1 instance)
            F387 (1 instance)
            F389 (1 instance)
            F39 (1 instance)
            F390 (1 instance)
            F392 (1 instance)
            F393 (1 instance)
            F394 (1 instance)
            F395 (1 instance)
            F398 (1 instance)
            F4 (1 instance)
            F40 (1 instance)
            F405 (1 instance)
            F406 (1 instance)
            F407 (1 instance)
            F41 (1 instance)
            F410 (1 instance)
            F411 (1 instance)
            F414 (1 instance)
            F416 (1 instance)
            F417 (1 instance)
            F418 (1 instance)
            F419 (1 instance)
            F42 (1 instance)
            F420 (1 instance)
            F421 (1 instance)
            F422 (1 instance)
            F423 (1 instance)
            F424 (1 instance)
            F426 (1 instance)
            F427 (1 instance)
            F428 (1 instance)
            F43 (1 instance)
            F430 (1 instance)
            F434 (1 instance)
            F436 (1 instance)
            F437 (1 instance)
            F438 (1 instance)
            F44 (1 instance)
            F440 (1 instance)
            F441 (1 instance)
            F442 (1 instance)
            F444 (1 instance)
            F449 (1 instance)
            F45 (1 instance)
            F450 (1 instance)
            F452 (1 instance)
            F454 (1 instance)
            F456 (1 instance)
            F457 (1 instance)
            F459 (1 instance)
            F46 (1 instance)
            F461 (1 instance)
            F464 (1 instance)
            F465 (1 instance)
            F466 (1 instance)
            F468 (1 instance)
            F469 (1 instance)
            F470 (1 instance)
            F471 (1 instance)
            F472 (1 instance)
            F473 (1 instance)
            F474 (1 instance)
            F48 (1 instance)
            F49 (1 instance)
            F5 (1 instance)
            F51 (1 instance)
            F52 (1 instance)
            F53 (1 instance)
            F55 (1 instance)
            F56 (1 instance)
            F57 (1 instance)
            F58 (1 instance)
            F59 (1 instance)
            F61 (1 instance)
            F62 (1 instance)
            F63 (1 instance)
            F64 (1 instance)
            F65 (1 instance)
            F66 (1 instance)
            F67 (1 instance)
            F68 (1 instance)
            F69 (1 instance)
            F70 (1 instance)
            F71 (1 instance)
            F72 (1 instance)
            F73 (1 instance)
            F74 (1 instance)
            F75 (1 instance)
            F76 (1 instance)
            F77 (1 instance)
            F78 (1 instance)
            F79 (1 instance)
            F8 (1 instance)
            F80 (1 instance)
            F81 (1 instance)
            F82 (1 instance)
            F84 (1 instance)
            F85 (1 instance)
            F86 (1 instance)
            F87 (1 instance)
            F88 (1 instance)
            F9 (1 instance)
            F90 (1 instance)
            F91 (1 instance)
            F92 (1 instance)
            F93 (1 instance)
            F94 (1 instance)
            F95 (1 instance)
            F96 (1 instance)
            F97 (1 instance)
            F98 (1 instance)
    Information:
        None"
checkResults essent-voorschotten "Cleanup Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains conservatively compressed streams: 
            Uncompressed: (2333 instances)"
echo

# Userdata, Cleanup
runTest extractFrom extractFrom.pdf
checkResults extractFrom "Userdata Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains annotations: 
            SubType: FileAttachment (3 instances)
        Contains embedded files: 
            Total: (4 instances)
        Contains metadata: 
            SubType: XML, Update region size: 2048 (1 instance)"
checkResults extractFrom "Cleanup Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains conservatively compressed streams: 
            Uncompressed: (1 instance)"
echo

# Userdata, Cleanup, Image - Color, Monochrome
runTest findImageResolutions FindImageResolutions.pdf
checkResults findImageResolutions "Userdata Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains metadata: 
            SubType: XML, Update region size: 2048 (1 instance)
        Contains transparency: 
            Total: (1 instance)"
checkResults findImageResolutions "Cleanup Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains conservatively compressed streams: 
            Uncompressed: (61 instances)"
checkResults findImageResolutions "Color Images" "Checks Completed" "    Errors:
        None
    Information:
        High resolution color image(s) present: 
            Total: (8 instances)
        Low resolution color image(s) present: 
            Total: (8 instances)"
checkResults findImageResolutions "Monochrome Images" "Checks Completed" "    Errors:
        None
    Information:
        Low resolution monochrome image(s) present: 
            Total: (2 instances)"
echo

# General
runTest hello-broken_1 hello-broken_1.pdf
checkResults hello-broken_1 "General Results" "Checks Aborted" "    Errors:
        Cannot be opened/not valid PDF
    Information:
        None
    Checks Completed:
        unable-to-open (triggered abort)"
echo

# Userdata, Fonts, Objects
runTest JavaScriptClock JavaScriptClock.pdf
checkResults JavaScriptClock "Userdata Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains annotations: 
            SubType: Link (1 instance)
            SubType: Widget (33 instances)
        Contains annotations that are set as invisible for printing: 
            SubType: Link (1 instance)
        Contains embedded files: 
            Total: (1 instance)
        Contains metadata: 
            SubType: XML, Update region size: 2048 (1 instance)"
checkResults JavaScriptClock "Fonts Results" "Checks Completed" "    Errors:
        Uses Base 14 fonts not embedded in document: 
            Arial-BoldMT (1 instance)
            Helvetica (1 instance)
            Helvetica-Bold (1 instance)
            TimesNewRomanPS-ItalicMT (1 instance)
            TimesNewRomanPSMT (1 instance)
    Information:
        None"
checkResults JavaScriptClock "Objects Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains JavaScript actions: 
            Type: Annot, SubType: Widget (20 instances)"
echo

# Userdata, Fonts, Cleanup, Image - Grayscale, Monochrome
runTest locallyBuiltSample LocallyBuiltSample.pdf
checkResults locallyBuiltSample "Userdata Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains embedded files: 
            Total: (1 instance)
        Contains metadata: 
            SubType: XML, Update region size: 2048 (1 instance)"
checkResults locallyBuiltSample "Fonts Results" "Checks Completed" "    Errors:
        None
    Information:
        Uses fonts fully embedded in document: 
            CourierStd (1 instance)"
checkResults locallyBuiltSample "Cleanup Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains conservatively compressed streams: 
            Compression: ASCII (3 instances)
            Compression: LZW (1 instance)
            Uncompressed: (5 instances)"
checkResults locallyBuiltSample "Grayscale Images" "Checks Completed" "    Errors:
        None
    Information:
        High resolution gray image(s) present: 
            Total: (3 instances)
        Low resolution gray image(s) present: 
            Total: (3 instances)"
checkResults locallyBuiltSample "Monochrome Images" "Checks Completed" "    Errors:
        None
    Information:
        Low resolution monochrome image(s) present: 
            Total: (1 instance)"
echo

# Userdata, Fonts, Objects, Cleanup, Image - Color
runTest matrix2DOperationsJavascriptOperations Matrix2DOperationsJavascriptOperations.pdf
checkResults matrix2DOperationsJavascriptOperations "Userdata Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains annotations: 
            SubType: Popup (1 instance)
            SubType: Text (1 instance)
            SubType: Widget (66 instances)
        Contains embedded files: 
            Total: (1 instance)
        Contains metadata: 
            SubType: XML, Update region size: 2048 (1 instance)"
checkResults matrix2DOperationsJavascriptOperations "Fonts Results" "Checks Completed" "    Errors:
        Uses Base 14 fonts not embedded in document: 
            Arial (4 instances)
            ArialMT (1 instance)
            Helvetica (16 instances)
            Helvetica-Bold (1 instance)
            Helvetica-BoldOblique (1 instance)
            Times-Bold (1 instance)
            Times-BoldItalic (1 instance)
            Times-Roman (1 instance)
            ZapfDingbats (1 instance)
    Information:
        Uses fonts fully embedded in document: 
            CalifornianFB (2 instances)"
checkResults matrix2DOperationsJavascriptOperations "Objects Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains JavaScript actions: 
            Type: Annot, SubType: Widget (23 instances)"
checkResults matrix2DOperationsJavascriptOperations "Cleanup Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains conservatively compressed streams: 
            Uncompressed: (4 instances)"
checkResults matrix2DOperationsJavascriptOperations "Color Images" "Checks Completed" "    Errors:
        None
    Information:
        Color image(s) using JPEG2000 compression: 
            Total: (1 instance)"
echo

# General, Userdata
runTest ownerPassword OwnerPassword.pdf
checkResults ownerPassword "General Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains owner password"
checkResults ownerPassword "Userdata Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains metadata: 
            SubType: XML, Update region size: 0 (1 instance)"
echo

# General, Userdata, Fonts, Cleanup
runTest pdf_2.0_with_page_level_output_intent PDF_2.0_with_page_level_output_intent.pdf
checkResults pdf_2.0_with_page_level_output_intent "General Results" "Checks Completed" "    Errors:
        None
    Information:
        PDF 2.0 document"
checkResults pdf_2.0_with_page_level_output_intent "Userdata Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains metadata: 
            SubType: XML, Update region size: 0 (1 instance)"
checkResults pdf_2.0_with_page_level_output_intent "Fonts Results" "Checks Completed" "    Errors:
        Uses Base 14 fonts not embedded in document: 
            Helvetica (1 instance)
    Information:
        None"
checkResults pdf_2.0_with_page_level_output_intent "Cleanup Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains conservatively compressed streams: 
            Uncompressed: (4 instances)"
echo

# Userdata, Cleanup
runTest pdfAnnotationtestfile-noappearances PDFannotationtestfile-noappearances.pdf
checkResults pdfAnnotationtestfile-noappearances "Userdata Results" "Checks Completed" "    Errors:
        Contains annotations without default normal appearances. These may not be displayed correctly by all PDF viewers: 
            SubType: Circle (1 instance)
            SubType: FreeText (2 instances)
            SubType: Highlight (1 instance)
            SubType: Ink (1 instance)
            SubType: Line (2 instances)
            SubType: Polygon (2 instances)
            SubType: Popup (11 instances)
            SubType: Square (1 instance)
            SubType: Stamp (1 instance)
            SubType: StrikeOut (1 instance)
            SubType: Underline (1 instance)
    Information:
        Contains annotations: 
            SubType: Circle (1 instance)
            SubType: FreeText (2 instances)
            SubType: Highlight (1 instance)
            SubType: Ink (1 instance)
            SubType: Line (2 instances)
            SubType: Polygon (2 instances)
            SubType: Popup (11 instances)
            SubType: Square (1 instance)
            SubType: Stamp (1 instance)
            SubType: StrikeOut (1 instance)
            SubType: Underline (1 instance)
        Contains embedded files: 
            Total: (1 instance)
        Contains metadata: 
            SubType: XML, Update region size: 2048 (1 instance)"
checkResults pdfAnnotationtestfile-noappearances "Cleanup Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains conservatively compressed streams: 
            Uncompressed: (4 instances)"
echo

# Userdata, Fonts, Cleanup
runTest pdfAnnotationtestfile-withappearances PDFannotationtestfile-withappearances.pdf
checkResults pdfAnnotationtestfile-withappearances "Userdata Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains annotations: 
            SubType: Circle (1 instance)
            SubType: FreeText (2 instances)
            SubType: Highlight (1 instance)
            SubType: Ink (1 instance)
            SubType: Line (2 instances)
            SubType: Polygon (2 instances)
            SubType: Popup (11 instances)
            SubType: Square (1 instance)
            SubType: Stamp (1 instance)
            SubType: StrikeOut (1 instance)
            SubType: Underline (1 instance)
        Contains embedded files: 
            Total: (1 instance)
        Contains metadata: 
            SubType: XML, Update region size: 2048 (1 instance)
        Contains transparency: 
            Total: (1 instance)"
checkResults pdfAnnotationtestfile-withappearances "Fonts Results" "Checks Completed" "    Errors:
        Uses Base 14 fonts not embedded in document: 
            Helvetica (1 instance)
            Helvetica-BoldOblique (1 instance)
    Information:
        None"
checkResults pdfAnnotationtestfile-withappearances "Cleanup Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains conservatively compressed streams: 
            Uncompressed: (4 instances)"
echo

# General, Userdata, Fonts, Cleanup
runTest signed_Gibson_PKCS7_DETACHED_Sha256 Signed_Gibson_PKCS7_DETACHED_Sha256.pdf
checkResults signed_Gibson_PKCS7_DETACHED_Sha256 "General Results" "Checks Completed" "    Errors:
        None
    Information:
        Signed document"
checkResults signed_Gibson_PKCS7_DETACHED_Sha256 "Userdata Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains annotations: 
            SubType: Widget (1 instance)"
checkResults signed_Gibson_PKCS7_DETACHED_Sha256 "Fonts Results" "Checks Completed" "    Errors:
        Uses Base 14 fonts not embedded in document: 
            Helvetica (1 instance)
    Information:
        None"
checkResults signed_Gibson_PKCS7_DETACHED_Sha256 "Cleanup Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains conservatively compressed streams: 
            Uncompressed: (5 instances)"
echo

# General, Fonts, Cleanup
runTest simplePDF2.0file SimplePDF2.0file.pdf
checkResults simplePDF2.0file "General Results" "Checks Completed" "    Errors:
        None
    Information:
        PDF 2.0 document"
checkResults simplePDF2.0file "Fonts Results" "Checks Completed" "    Errors:
        Uses Base 14 fonts not embedded in document: 
            Helvetica (1 instance)
    Information:
        None"
checkResults simplePDF2.0file "Cleanup Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains conservatively compressed streams: 
            Uncompressed: (2 instances)"
echo

# Userdata, Objects, Cleanup
runTest test_contains_private_data Test_contains_private_data.pdf
checkResults test_contains_private_data "Userdata Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains metadata: 
            SubType: XML, Update region size: 2048 (1 instance)
        Contains optional content (layers)
        Contains application private data: 
            Total: (1 instance)
        Contains transparency: 
            Total: (1 instance)"
checkResults test_contains_private_data "Objects Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains page thumbnail images: 
            Total: (1 instance)"
checkResults test_contains_private_data "Cleanup Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains conservatively compressed streams: 
            Compression: ASCII (2 instances)
            Uncompressed: (17 instances)"
echo

# General, Userdata, Fonts, Objects, Cleanup
runTest theFlyv3_EN4Rdr TheFlyv3_EN4Rdr.pdf
checkResults theFlyv3_EN4Rdr "General Results" "Checks Completed" "    Errors:
        None
    Information:
        Signed document"
checkResults theFlyv3_EN4Rdr "Userdata Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains annotations: 
            SubType: Link (1 instance)
            SubType: Popup (1 instance)
            SubType: Text (1 instance)
            SubType: Widget (12 instances)
        Contains annotations that are set as invisible for printing: 
            SubType: Link (1 instance)
        Contains embedded files: 
            Total: (1 instance)
        Contains metadata: 
            SubType: XML, Update region size: 2048 (1 instance)
        Contains optional content (layers)
        Contains transparency: 
            Total: (1 instance)"
checkResults theFlyv3_EN4Rdr "Fonts Results" "Checks Completed" "    Errors:
        Uses Base 14 fonts not embedded in document: 
            Arial,Bold (2 instances)
            Helvetica (1 instance)
            Helvetica-Bold (2 instances)
    Information:
        None"
checkResults theFlyv3_EN4Rdr "Objects Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains JavaScript actions: 
            Type: Annot, SubType: Widget (6 instances)"
checkResults theFlyv3_EN4Rdr "Cleanup Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains conservatively compressed streams: 
            Uncompressed: (4 instances)"
echo

#Userdata, Fonts
runTest theWarOfTheWorlds TheWarOfTheWorlds.pdf
checkResults theWarOfTheWorlds "Userdata Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains annotations: 
            SubType: Link (12 instances)
            SubType: Popup (1 instance)
            SubType: Text (1 instance)
        Contains annotations that are set as invisible for printing: 
            SubType: Link (12 instances)
        Contains embedded files: 
            Total: (1 instance)
        Contains metadata: 
            SubType: XML, Update region size: 2048 (1 instance)
        Contains transparency: 
            Total: (173 instances)"
checkResults theWarOfTheWorlds "Fonts Results" "Checks Completed" "    Errors:
        None
    Information:
        Uses fonts fully embedded in document: 
            DejaVuSerif (1 instance)
            DejaVuSerif,Bold (1 instance)
            DejaVuSerif,Italic (1 instance)"
echo

# Userdata, Fonts, Cleanup
runTest fontDesc PDFCHECK-34.pdf
checkResults fontDesc "Userdata Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains metadata: 
            SubType: XML, Update region size: 2048 (1 instance)
        Contains transparency: 
            Total: (1 instance)"
checkResults fontDesc "Fonts Results" "Checks Completed" "    Errors:
        FontDescriptor has missing required fields: 
            ArialNarrow-Bold, SubType: TrueType, Missing: Ascent Descent (1 instance)
    Information:
        Uses fonts fully embedded in document: 
            Arial-BoldMT (1 instance)
            ArialMT (1 instance)
            ArialNarrow (2 instances)
            ArialNarrow-Bold (1 instance)
            BankGothicBT-Light (1 instance)
            Tahoma (1 instance)"
checkResults fontDesc "Cleanup Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains conservatively compressed streams: 
            Uncompressed: (300 instances)"
echo

# Userdata, Fonts, Cleanup
runTest fontDescA PDFCHECK-34a.pdf
checkResults fontDesc "Userdata Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains metadata: 
            SubType: XML, Update region size: 2048 (1 instance)
        Contains transparency: 
            Total: (1 instance)"
checkResults fontDescA "Fonts Results" "Checks Completed" "    Errors:
        FontDescriptor has missing required fields: 
            ArialNarrow-Bold, SubType: TrueType, Missing: Ascent Descent (1 instance)
    Information:
        FontDescriptor is missing potentially required CapHeight field: 
            ArialNarrow, SubType: TrueType (1 instance)
            ArialNarrow, SubType: Type0 (1 instance)
        Uses fonts fully embedded in document: 
            Arial-BoldMT (1 instance)
            ArialMT (1 instance)
            ArialNarrow (2 instances)
            ArialNarrow-Bold (1 instance)
            BankGothicBT-Light (1 instance)
            Tahoma (1 instance)"
checkResults fontDescA "Cleanup Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains conservatively compressed streams: 
            Uncompressed: (300 instances)"
echo

# Userdata, Fonts, Cleanup, Color Images, Grayscale Images, Monochrome Images
runTest manyImagesStreamsFonts DocWithManyImagesAndStreamsAndFonts.pdf
checkResults manyImagesStreamsFonts "Userdata Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains metadata: 
            SubType: XML, Update region size: 0 (101 instances)
            SubType: XML, Update region size: 2048 (2 instances)
        Contains optional content (layers)
        Contains transparency: 
            Total: (1 instance)"
checkResults manyImagesStreamsFonts "Fonts Results" "Checks Completed" "    Errors:
        None
    Information:
        Uses fonts fully embedded in document: 
            AdobeHebrew-Regular (1 instance)
            AdobeThai-Regular (1 instance)
            BirchStd (2 instances)
            Centennial-Light (1 instance)
            Centennial-LightItalic (1 instance)
            Courier (6 instances)
            MyriadPro-Bold (18 instances)
            MyriadPro-It (1 instance)
            MyriadPro-Regular (2 instances)
            PoplarStd (2 instances)
            Symbol (1 instance)"
checkResults manyImagesStreamsFonts "Cleanup Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains conservatively compressed streams: 
            Uncompressed: (10 instances)"
checkResults manyImagesStreamsFonts "Color Images" "Checks Completed" "    Errors:
        None
    Information:
        16-bit/channel color image(s) present: 
            Total: (5 instances)
        High resolution color image(s) present: 
            Total: (22 instances)
        Low resolution color image(s) present: 
            Total: (42 instances)
        Color image(s) using JPEG2000 compression: 
            Total: (10 instances)"
checkResults manyImagesStreamsFonts "Grayscale Images" "Checks Completed" "    Errors:
        None
    Information:
        High resolution gray image(s) present: 
            Total: (1 instance)
        Low resolution gray image(s) present: 
            Total: (14 instances)
        Grayscale image(s) using JPEG2000 compression: 
            Total: (2 instances)"
checkResults manyImagesStreamsFonts "Monochrome Images" "Checks Completed" "    Errors:
        None
    Information:
        Low resolution monochrome image(s) present: 
            Total: (12 instances)"
echo

runTest UnableToOpen brokenpdf.pdf
checkResults UnableToOpen "General Results" "Userdata Results" "    Errors:
        Damaged document
        Cannot be opened/not valid PDF
    Information:
        None
    Checks Completed:
        damaged
        unable-to-open (triggered abort)
    Checks Aborted:
        claims-pdfa-conformance
        contains-owner-password
        contains-signature
        password-protected
        pdf-v2
        xfa-type"
#fileComp UnableToOpen
echo

runTest PasswordProtected Encrypted.pdf 
checkResults PasswordProtected "General Results" "Userdata Results" "    Errors:
        Requires password for opening
        Cannot be opened/not valid PDF
    Information:
        None
    Checks Completed:
        password-protected (triggered abort)
        unable-to-open (triggered abort)
    Checks Aborted:
        claims-pdfa-conformance
        contains-owner-password
        contains-signature
        damaged
        pdf-v2
        xfa-type"
#fileComp PasswordProtected
echo

runTest ContainsOwnerPassword OwnerPassword.pdf 
checkResults ContainsOwnerPassword "General Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains owner password"
#fileComp ContainsOwnerPassword
echo

runTest XfaDoc XFAExample.pdf 
checkResults XfaDoc "General Results" "Checks Completed" "    Errors:
        None
    Information:
        Signed document
        XFA document"
#fileComp XfaDoc
echo

runTest PDFv2 SimplePDF2.0file.pdf 
checkResults PDFv2 "General Results" "Checks Completed" "    Errors:
        None
    Information:
        PDF 2.0 document"
#fileComp PDFv2
echo

runTest NonEmbeddedFonts Verdana-Unembedded.pdf 
checkResults NonEmbeddedFonts "Fonts Results" "Checks Completed" "    Errors:
        Uses Base 14 fonts not embedded in document: 
            Arial (1 instance)
            Arial,Bold (1 instance)
            TimesNewRoman (1 instance)
            TimesNewRoman,Italic (1 instance)
        Uses fonts not embedded in document: 
            CourierStd (1 instance)
            Meiryo (1 instance)
            Verdana (3 instances)
    Information:
        None"
#fileComp NonEmbeddedFonts
echo

runTest JavaScriptActions Matrix2DOperationsJavascriptOperations.pdf 
checkResults JavaScriptActions "Objects Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains JavaScript actions: 
            Type: Annot, SubType: Widget (23 instances)"
#fileComp JavaScriptActions
echo

runTest ContainsAnnotations PDFannotationtestfile-withappearances.pdf 
checkResults ContainsAnnotations "Userdata Results" "Checks Completed" "    Errors:
        None
    Information:
        Contains annotations: 
            SubType: Circle (1 instance)
            SubType: FreeText (2 instances)
            SubType: Highlight (1 instance)
            SubType: Ink (1 instance)
            SubType: Line (2 instances)
            SubType: Polygon (2 instances)
            SubType: Popup (11 instances)
            SubType: Square (1 instance)
            SubType: Stamp (1 instance)
            SubType: StrikeOut (1 instance)
            SubType: Underline (1 instance)
        Contains embedded files: 
            Total: (1 instance)
        Contains metadata: 
            SubType: XML, Update region size: 2048 (1 instance)
        Contains transparency: 
            Total: (1 instance)"
#fileComp ContainsAnnotations
echo

runTest ContainsAnnotNonNormal PDFannotationtestfile-noappearances.pdf 
checkResults ContainsAnnotNonNormal "Userdata Results" "Checks Completed" "    Errors:
        Contains annotations without default normal appearances. These may not be displayed correctly by all PDF viewers: 
            SubType: Circle (1 instance)
            SubType: FreeText (2 instances)
            SubType: Highlight (1 instance)
            SubType: Ink (1 instance)
            SubType: Line (2 instances)
            SubType: Polygon (2 instances)
            SubType: Popup (11 instances)
            SubType: Square (1 instance)
            SubType: Stamp (1 instance)
            SubType: StrikeOut (1 instance)
            SubType: Underline (1 instance)
    Information:
        Contains annotations: 
            SubType: Circle (1 instance)
            SubType: FreeText (2 instances)
            SubType: Highlight (1 instance)
            SubType: Ink (1 instance)
            SubType: Line (2 instances)
            SubType: Polygon (2 instances)
            SubType: Popup (11 instances)
            SubType: Square (1 instance)
            SubType: Stamp (1 instance)
            SubType: StrikeOut (1 instance)
            SubType: Underline (1 instance)
        Contains embedded files: 
            Total: (1 instance)
        Contains metadata: 
            SubType: XML, Update region size: 2048 (1 instance)"
#fileComp ContainsAnnotNonNormal

# General, Userdata, Cleanup
runTest AdditionalChecksDamagedFiles amitavas_coke.pdf
checkResults AdditionalChecksDamagedFiles "General Results" "Userdata Results" "    Errors:
        Damaged document
    Information:
        None
    Checks Completed:
        claims-pdfa-conformance
        contains-owner-password
        contains-signature
        damaged
        password-protected
        pdf-v2
        unable-to-open
        xfa-type"
checkResults AdditionalChecksDamagedFiles "Userdata Results" "Fonts Results" "    Errors:
        None
    Information:
        None
    Checks Completed:
        contains-annots
        contains-annots-not-for-printing
        contains-annots-not-for-viewing
        contains-annots-without-normal-appearances
        contains-embedded-files
        contains-metadata
        contains-optional-content
        contains-private-data
        contains-transparency"
checkResults AdditionalChecksDamagedFiles "Cleanup Results" "Image Results" "    Errors:
        None
    Information:
        Contains conservatively compressed streams: 
            Compression: ASCII (2 instances)
    Checks Completed:
        suboptimal-compression"
echo


echo 
echo "----------------------------------"
echo "Checker Baseline Tests Executed"
echo "----------------------------------"
