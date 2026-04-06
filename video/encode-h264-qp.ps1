
Param($qpi, $qpp, $inputFileName)

# Checked either specified input file or not.
if ($null -eq $inputFileName) {
    Write-Host 'Notice : There is not first parameter. Please input target file pass as first parameter.'
    Write-Host 'Notice : Stop a script...'
    exit
}

$jsonFileName = ".\tmp-loudness-$inputFileName.json"

Write-Host '[' (Get-Date -Format 'yyyy/MM/dd HH:mm:ss') ']' "Checking the loudness... : $inputFileName"
ffmpeg -i $inputFileName -filter:a loudnorm=I=-14:LRA=23:TP=-1:offset=0:print_format=json -vn -f null - -hide_banner 2> $jsonFileName
Write-Host '[' (Get-Date -Format 'yyyy/MM/dd HH:mm:ss') ']' 'Completed checking the loudness.'

# Generate json file recording loudness information of video
$jsonData = Get-Content -Path $jsonFileName -Tail 15
Out-File -FilePath $jsonFileName -InputObject $jsonData
$jsonData = Get-Content -Path $jsonFileName -TotalCount 12
Out-File -FilePath $jsonFileName -InputObject $jsonData

# Built values of filter option.
$jsonData = Get-Content -Raw $jsonFileName | ConvertFrom-Json
$audioFilterContent = 'loudnorm=I=-14:LRA=23:TP=-1:offset=0' `
    + ":measured_I=$($jsonData.input_i)" `
    + ":measured_TP=$($jsonData.input_tp)" `
    + ":measured_LRA=$($jsonData.input_lra)" `
    + ":measured_thresh=$($jsonData.input_thresh)" `
    + ":offset=$($jsonData.target_offset)" `
    + ':linear=false' `
    + ',anlmdn=s=0.00001:p=0.002:r=0.004'

Remove-Item $jsonFileName

$timeStamp = Get-Date -Format 'yyyy/MM/dd HH:mm:ss'
Out-File -FilePath '.\loudnessLogs.txt' -InputObject "[ $timeStamp ] $inputFileName > qpi=$qpi qpp=$qpp $audioFilterContent" -Append

ffmpeg -i $inputFileName `
    -codec:v h264_nvenc -rc:v constqp -init_qpI $qpi -init_qpP $qpp -g 120 -fps_mode cfr -r 60 -tune hq -multipass fullres -profile:v high `
    -codec:a aac -aac_coder twoloop -b:a 192k -ar: 48k -async 2 -af $audioFilterContent `
    -hide_banner output-$inputFileName

Write-Host '[' (Get-Date -Format 'yyyy/MM/dd HH:mm:ss') ']' 'End encode video.'
