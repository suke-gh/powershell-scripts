
Param($inputFile)

# Checked either specified input file or not.
if ($null -eq $inputFile) {
    Write-Host 'Notice : There is not first parameter. Please input target file pass as first parameter.'
    Write-Host 'Notice : Stop a script...'
    exit
}

Write-Host "Checking the loudness... : ${inputFile}"
$jsonFile = "loudness-${inputFile}.json"
ffmpeg -i ${inputFile} -filter:a loudnorm=I=-14:LRA=23:TP=-1:offset=0:print_format=json -vn -f null - -hide_banner 2> ${jsonFile}
Get-Content ${jsonFile} -Tail 12 | Tee-Object -FilePath ${jsonFile}

# Built values of filter option.
$jsonData = Get-Content -Raw $jsonFile | ConvertFrom-Json
$audioFilterContent = "loudnorm=I=-14:LRA=23:TP=-1:offset=0:" `
    + "measured_I=$($jsonData.input_i):" `
    + "measured_TP=$($jsonData.input_tp):" `
    + "measured_LRA=$($jsonData.input_lra):" `
    + "measured_thresh=$($jsonData.input_thresh):" `
    + "offset=$($jsonData.target_offset):" `
    + 'linear=false,anlmdn=s=0.00001:p=0.002:r=0.002'

$timeStamp = Get-Date -Format "yyyy/MM/dd HH:mm:ss"
Out-File -FilePath ".\loudnessLogs.txt" -InputObject "[${timeStamp}] (${inputFile}) ${audioFilterContent}" -Append

ffmpeg -i ${inputFile} `
    -codec:v copy `
    -codec:a aac -aac_coder twoloop -b:a 192k -ar: 48k -async 2 -af ${audioFilterContent} `
    -hide_banner output-${inputFile}

Remove-Item $jsonFile
