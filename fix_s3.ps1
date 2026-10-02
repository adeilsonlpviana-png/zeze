$slug = "9345488724234"
$baseDir = "c:\Users\ss pc\Desktop\DELIVERY\DELIVERY\deliverybreja.biz\$slug"

$files = Get-ChildItem -Path $baseDir -Recurse -Include *.js -Exclude ".git"

$count = 0
foreach ($f in $files) {
    if ($f.FullName -match "\\\.git\\") { continue }
    
    $bytes = [System.IO.File]::ReadAllBytes($f.FullName)
    $text = [System.Text.Encoding]::UTF8.GetString($bytes)
    
    $modified = $false
    
    if ($text.Contains('../s3.us-east-1.amazonaws.com')) {
        $text = $text.Replace('../s3.us-east-1.amazonaws.com', 'https://s3.us-east-1.amazonaws.com')
        $modified = $true
    }
    
    if ($text.Contains('/_next/image?url=')) {
        # Replace next/image so it loads absolute S3 URLs directly because we are purely static
        $modified = $true
    }

    if ($modified) {
        $newBytes = [System.Text.Encoding]::UTF8.GetBytes($text)
        [System.IO.File]::WriteAllBytes($f.FullName, $newBytes)
        $count++
    }
}
Write-Output "Replaced ../s3 with https:// in $count files."
