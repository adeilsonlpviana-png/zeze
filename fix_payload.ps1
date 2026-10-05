$htmlFiles = @(Get-ChildItem -Path "c:\Users\ss pc\Desktop\DELIVERY\DELIVERY\deliverybreja.biz\9345488724234" -Recurse -Filter "*.html") + @(Get-ChildItem -Path "c:\Users\ss pc\Desktop\DELIVERY\DELIVERY\deliverybreja.biz" -Filter "*.html")

foreach ($file in $htmlFiles) {
    if ($file.FullName -match "\.html$") {
        $text = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
        $changed = $false
        
        # Replace the description in items
        if ($text -match "description: 'Endere\\u00e7o: ' \+ enderecoCompleto,") {
            $text = $text -replace "description: 'Endere\\u00e7o: ' \+ enderecoCompleto,", ""
            $changed = $true
        }
        
        # Add metadata before pix:
        if ($changed -and $text -match "pix: \{ expiresInDays: 1 \}") {
            if (-not $text.Contains("metadata: 'Endere\u00e7o: ' + enderecoCompleto,")) {
                $text = $text -replace "pix: \{ expiresInDays: 1 \}", "metadata: 'Endere\u00e7o: ' + enderecoCompleto,`n          pix: { expiresInDays: 1 }"
            }
        }
        
        if ($changed) {
            [System.IO.File]::WriteAllText($file.FullName, $text, [System.Text.Encoding]::UTF8)
        }
    }
}
