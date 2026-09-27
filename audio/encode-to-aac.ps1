
Param($format)

# Checked either specified a format or not.
if ($null -eq $format) {
    Write-Host 'Notice : There is not first parameter. Please input target file pass as first parameter.'
    Write-Host 'Notice : Stop a script...'
    exit
}

# Created a directory for encoded audio file.
$dirName = 'encoded - m4a'
New-Item -Path '.\' -Name $dirName -ItemType 'directory' -Force

foreach ($inputFileName in Get-ChildItem -Filter *.$format ) {
    $outputFilePass = ".\$dirName\$inputFileName".Replace('.' + $format,'.m4a').ToString()
    $metaTitle      = "$inputFileName".Replace(".$format", '').ToString()
    $jsonFileName   = ".\tmp-$inputFileName-loudness.json"

    Write-Host '[' (Get-Date -Format 'yyyy/MM/dd HH:mm:ss') ']' "Checking the loudness... : $inputFileName"
    ffmpeg -i $inputFileName -filter:a loudnorm=I=-14:LRA=23:TP=-1:offset=0:print_format=json -vn -f null - -hide_banner 2> $jsonFileName
    Write-Host '[' (Get-Date -Format 'yyyy/MM/dd HH:mm:ss') ']' 'End checking the loudness.'

    # Generate json file recording loudness information of video
    $jsonData = Get-Content -Path $jsonFileName -Tail 15
    Out-File -FilePath $jsonFileName -InputObject $jsonData
    $jsonData = Get-Content -Path $jsonFileName -TotalCount 12
    Out-File -FilePath $jsonFileName -InputObject $jsonData

    # Built values of filter option.
    $jsonData = Get-Content -Raw $jsonFileName | ConvertFrom-Json
    $filterContent = 'loudnorm=I=-14:LRA=23:TP=-1:offset=0' `
        + ":measured_I=$($jsonData.input_i)" `
        + ":measured_TP=$($jsonData.input_tp)" `
        + ":measured_LRA=$($jsonData.input_lra)" `
        + ":measured_thresh=$($jsonData.input_thresh)" `
        + ":offset=$($jsonData.target_offset)" `
        + ':linear=false,anlmdn=s=0.0001:p=0.002:r=0.005:o=1:m=11'

    Remove-Item $jsonFileName

    ffmpeg -i "$inputFileName" -hide_banner -vn -codec:a aac -aac_coder twoloop -b:a 192k -ar 48k -metadata title="$metaTitle" -filter:a $filterContent -hide_banner "$outputFilePass"
}

Write-Host '[' (Get-Date -Format 'yyyy/MM/dd HH:mm:ss') ']' 'End encode audio file.'
