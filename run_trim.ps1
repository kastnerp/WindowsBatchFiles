$skipPatterns = @('paper*.pdf', 'sub*.pdf')

Get-ChildItem -Recurse -Include @('*.pdf', '*.jpg', '*.png') | ForEach-Object {
    $srcFile = $_
    
    # Skip files that match patterns in $skipPatterns
    $skipThisFile = $false
    foreach ($pattern in $skipPatterns) {
        if ($srcFile.Name -like $pattern) {
            $skipThisFile = $true
            break
        }
    }
    
    if ($skipThisFile) {
        continue
    }

    $cropFile = if ($srcFile.BaseName -like "*-crop") {
                   Join-Path $srcFile.DirectoryName ($srcFile.BaseName + $srcFile.Extension)
               } else {
                   Join-Path $srcFile.DirectoryName ($srcFile.BaseName + "-crop" + $srcFile.Extension)
               }

    if ((-not (Test-Path $cropFile)) -or ((Test-Path $cropFile) -and ($srcFile.LastWriteTime -gt (Get-Item $cropFile).LastWriteTime))) {
        switch ($srcFile.Extension) {
            ".pdf" {
                # your pdfcrop command here
                pdfcrop $srcFile.FullName $cropFile
            }
            ".jpg" {
                # your imagemagick command here
                magick $srcFile.FullName -trim $cropFile
            }
            ".png" {
                # your imagemagick command here
                magick $srcFile.FullName -trim $cropFile
            }
        }
    }
}
