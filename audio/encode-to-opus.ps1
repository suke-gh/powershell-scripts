
Param($format)

# Checked either specified a format or not.
if ($null -eq $format) {
    Write-Host 'Notice : There is not first parameter. Please enter target file pass as first parameter.'
    Write-Host 'Notice : Stop a script...'
    exit
}

# Created a directory for encoded audio file.
$dirName = 'opus'
New-Item -Path . -Name $dirName -ItemType 'directory' -Force

foreach ($inputFile in Get-ChildItem -Filter *.${format} ) {
    $outputFilePass = "./${dirName}/" + "${inputFile}".Replace(${format},'opus')
    $jsonFile       = "loudness-${inputFile}.json"
    Write-Host "Checking the loudness... : ${inputFile}"

    # Wrote out loudness information of input audio file to json file.
    ffmpeg -i $inputFile -hide_banner -vn -filter:a loudnorm=I=-14:LRA=23:TP=-1:offset=0:print_format=json -f null - 2> $jsonFile
    Get-Content $jsonFile -Tail 12 | Tee-Object -FilePath $jsonFile

    # Built values of filter option.
    $jsonData      = Get-Content -Raw $jsonFile | ConvertFrom-Json
    $filterContent = "loudnorm=I=-14:LRA=23:TP=-1:offset=0" `
        + ":measured_I=$($jsonData.input_i)" `
        + ":measured_TP=$($jsonData.input_tp)" `
        + ":measured_LRA=$($jsonData.input_lra)" `
        + ":measured_thresh=$($jsonData.input_thresh)" `
        + ":offset=$($jsonData.target_offset)" `
        + ':linear=false,anlmdn=s=0.00001:p=0.002:r=0.002'
    Write-Host "filter info : ${filterContent}"

    ffmpeg -i "${inputFile}" -hide_banner -vn -codec:a libopus -b:a 160k -ar 48k -filter:a $filterContent "${outputFilePass}"

    Remove-Item $jsonFile
}
