$slug = "9345488724234"
$dir = "c:\Users\ss pc\Desktop\DELIVERY\DELIVERY\deliverybreja.biz\$slug"
$files = Get-ChildItem -Path $dir -Recurse -Include *.html,*.js

$replacements = @{
    '"/products/' = '"/' + $slug + '/products/'
    '"/_next/' = '"/' + $slug + '/_next/'
    '"/categoria/' = '"/' + $slug + '/categoria/'
    '"/produto/' = '"/' + $slug + '/produto/'
    '"/privacidade"' = '"/' + $slug + '/privacidade.html"'
    '"/termos"' = '"/' + $slug + '/termos.html"'
    '"/contato"' = '"/' + $slug + '/contato.html"'
    '"/trocas-devolucoes"' = '"/' + $slug + '/trocas-devolucoes.html"'
}

$count = 0
foreach ($f in $files) {
    $bytes = [System.IO.File]::ReadAllBytes($f.FullName)
    $text = [System.Text.Encoding]::UTF8.GetString($bytes)
    $modified = $false
    
    foreach ($key in $replacements.Keys) {
        if ($text.Contains($key)) {
            $text = $text.Replace($key, $replacements[$key])
            $modified = $true
        }
    }
    
    if ($modified) {
        $newBytes = [System.Text.Encoding]::UTF8.GetBytes($text)
        [System.IO.File]::WriteAllBytes($f.FullName, $newBytes)
        $count++
    }
}
Write-Output "Modified $count files to fix absolute paths."
