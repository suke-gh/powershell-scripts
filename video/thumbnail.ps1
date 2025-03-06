
Param($video, $time, $format)

# Checked either specified a format or not.
if ($null -eq $format) {
    Write-Host 'Notice : There is not 3rd parameter. This time, a thumbnail is generated as jpeg file.'
    $format = 'jpg'
}

# pameters
$frames     = 30
$rate       = 4
$colorRange = 'pc'

switch ($format) {
    avif {
        ffmpeg -ss ${time} -i "${video}" -hide_banner `
            -c:v libaom-av1 -crf 12 -still-picture 1 -tune ssim -denoise-noise-level 8 `
            -frames:v ${frames} -r ${rate} -color_range ${colorRange} -f image2 "./ss/%04d.avif"
        break
    }
    png {
        ffmpeg -ss ${time} -i "${video}" -hide_banner -frames:v ${frames} -r ${rate} -color_range ${colorRange} -q:v 0 -f image2 "./ss/%04d.png"
        break
    }
    Default {
        ffmpeg -ss ${time} -i "${video}" -hide_banner -frames:v ${frames} -r ${rate} -color_range ${colorRange} -pix_fmt yuvj420p -q:v 0 -f image2 "./ss/%04d.jpg"
        break
    }
}
