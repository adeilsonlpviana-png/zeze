$slug = "9345488724234"
$baseDir = "c:\Users\ss pc\Desktop\DELIVERY\DELIVERY\deliverybreja.biz\$slug"

$files = Get-ChildItem -Path $baseDir -Recurse -Include *.html,*.js -Exclude ".git"

$count = 0
foreach ($f in $files) {
    if ($f.FullName -match "\\\.git\\") { continue }
    
    $bytes = [System.IO.File]::ReadAllBytes($f.FullName)
    $text = [System.Text.Encoding]::UTF8.GetString($bytes)
    
    $modified = $false
    
    # Replace the old basePath
    if ($text.Contains('"/zeze/')) {
        $text = $text.Replace('"/zeze/', '"/9345488724234/')
        $modified = $true
    }
    
    # Also replace any "/zeze" (no trailing slash) just in case
    if ($text.Contains('"/zeze"')) {
        $text = $text.Replace('"/zeze"', '"/9345488724234"')
        $modified = $true
    }

    if ($modified) {
        $newBytes = [System.Text.Encoding]::UTF8.GetBytes($text)
        [System.IO.File]::WriteAllBytes($f.FullName, $newBytes)
        $count++
    }
}
Write-Output "Replaced /zeze/ with /$slug/ in $count files."
