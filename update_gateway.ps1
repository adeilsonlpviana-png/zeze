$htmlFiles = @(Get-ChildItem -Path "c:\Users\ss pc\Desktop\DELIVERY\DELIVERY\deliverybreja.biz\9345488724234" -Recurse -Filter "*.html") + @(Get-ChildItem -Path "c:\Users\ss pc\Desktop\DELIVERY\DELIVERY\deliverybreja.biz" -Filter "*.html")

$apiKey = "f3496353-b145-431a-91ac-1e47968b5b6f"

foreach ($file in $htmlFiles) {
    if ($file.FullName -match "\.html$") {
        $text = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
        $changed = $false
        
        if ($text.Contains('https://api.pufpag.com/v1/transactions')) {
            $text = $text.Replace('https://api.pufpag.com/v1/transactions', 'https://api-gateway.techbynet.com/api/user/transactions')
            $changed = $true
        }
        if ($text.Contains("'Authorization': FASTSOFT_AUTH,")) {
            $text = $text.Replace("'Authorization': FASTSOFT_AUTH,", "'x-api-key': '$apiKey',")
            $changed = $true
        }
        
        if ($changed) {
            [System.IO.File]::WriteAllText($file.FullName, $text, [System.Text.Encoding]::UTF8)
        }
    }
}
