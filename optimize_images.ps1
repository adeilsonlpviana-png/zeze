$slug = "9345488724234"
$baseDir = "c:\Users\ss pc\Desktop\DELIVERY\DELIVERY\deliverybreja.biz\$slug"

$files = Get-ChildItem -Path $baseDir -Recurse -Include *.js -Exclude ".git"

$count = 0
foreach ($f in $files) {
    if ($f.FullName -match "\\\.git\\") { continue }
    
    $bytes = [System.IO.File]::ReadAllBytes($f.FullName)
    $text = [System.Text.Encoding]::UTF8.GetString($bytes)
    
    $modified = $false
    
    # Use wsrv.nl to automatically compress and cache the heavy S3 images
    if ($text.Contains('https://s3.us-east-1.amazonaws.com')) {
        $text = $text.Replace('https://s3.us-east-1.amazonaws.com', 'https://wsrv.nl/?url=s3.us-east-1.amazonaws.com')
        $modified = $true
    }

    if ($modified) {
        $newBytes = [System.Text.Encoding]::UTF8.GetBytes($text)
        [System.IO.File]::WriteAllBytes($f.FullName, $newBytes)
        $count++
    }
}
Write-Output "Optimized S3 images in $count files."
