
Param($format, $video, $time)

# Checked either specified a format or not.
if ($null -eq $format) {
    Write-Host 'Notice : There is not 3rd parameter. This time, a thumbnail is generated as jpeg file.'
    $format = 'jpg'
}

# Search 'thumbnail' directory and create it.
$dirName = 'thumbnails'
Get-ChildItem -Path '.\' -Directory | Where-Object Name -Match "$dirName"
if ($Matches -eq $null) {
    Write-Host 'Created thumbnail directory.'
    New-Item -Path '.\' -Name $dirName -ItemType 'Directory'
}

# pameters
$frames     = 40
$rate       = 3
$colorRange = 'pc'
$filePass   = '.\' + $dirName + '\%04d'

switch ($format) {
    avif {
        ffmpeg -ss "$time" -i "$video" -hide_banner `
            -c:v libaom-av1 -crf 12 -still-picture 1 -tune ssim -denoise-noise-level 8 `
            -frames:v "$frames" -r "$rate" -color_range "$colorRange" -f image2 "$filePass.avif"
        break
    }
    png {
        ffmpeg -ss "$time" -i "$video" -hide_banner -frames:v "$frames" -r $rate -color_range "$colorRange" -q:v 0 -f image2 "$filePass.png"
        break
    }
    Default {
        ffmpeg -ss "$time" -i "$video" -hide_banner -frames:v "$frames" -r "$rate" -color_range "$colorRange" -pix_fmt yuvj420p -q:v 0 -f image2 "$filePass.jpg"
        break
    }
}
