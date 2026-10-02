$slug = "9345488724234"
$baseDir = "c:\Users\ss pc\Desktop\DELIVERY\DELIVERY\deliverybreja.biz\$slug"

$files = Get-ChildItem -Path $baseDir -Recurse -Include *.html,*.js -Exclude ".git"

$count = 0
foreach ($f in $files) {
    if ($f.FullName -match "\\\.git\\") { continue }
    
    $bytes = [System.IO.File]::ReadAllBytes($f.FullName)
    $text = [System.Text.Encoding]::UTF8.GetString($bytes)
    
    $modified = $false
    
    if ($text.Contains('"/hero-banner.png"')) {
        $text = $text.Replace('"/hero-banner.png"', '"/9345488724234/hero-banner.png"')
        $modified = $true
    }
    
    if ($text.Contains('"/favicon.svg"')) {
        $text = $text.Replace('"/favicon.svg"', '"/9345488724234/favicon.svg"')
        $modified = $true
    }
    
    if ($text.Contains('"/og-image.png"')) {
        $text = $text.Replace('"/og-image.png"', '"/9345488724234/og-image.png"')
        $modified = $true
    }

    if ($modified) {
        $newBytes = [System.Text.Encoding]::UTF8.GetBytes($text)
        [System.IO.File]::WriteAllBytes($f.FullName, $newBytes)
        $count++
    }
}
Write-Output "Replaced static image paths in $count files."
