$htmlFiles = @(Get-ChildItem -Path "c:\Users\ss pc\Desktop\DELIVERY\DELIVERY\deliverybreja.biz\9345488724234" -Recurse -Filter "*.html") + @(Get-ChildItem -Path "c:\Users\ss pc\Desktop\DELIVERY\DELIVERY\deliverybreja.biz" -Filter "*.html")

$oldToken = "Basic a3BfMzJmMzAwODg1MWM4ZDExOGNhM2U1MTI0YTQzNjhmOGZlZmU2MDRmYTg4NjU5ZTQ4MWE2YjgzZTA3ZDIyYmNkMzprc183MTUwNTc1YTUwNzZmYjNlZjQzODY1Nzk4NTg2NDIyMGIxNTM4M2E3NWE2MGIyN2YzZTYwNzk3MTQ0YzM3NmFh"
$newToken = "Basic a3BfNzQ2NzBlYTA2YjQwMTFkNmQzNzk0MDhmNzg5MTg0MWIzYjljOWU2ZGFjZjQ4MDhhNzdmMTM1MDY4MTUwMGQ1Nzprc180ODI0YjVkODI5ZGMwNjc4ZjVlZmY4ZWJkNzAzN2YzYzI4MTVlOTgxYjVmN2I4NTI0NDRlNWMxODIxMmNiYjdl"

foreach ($file in $htmlFiles) {
    if ($file.FullName -match "\.html$") {
        $text = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
        if ($text.Contains($oldToken)) {
            $text = $text.Replace($oldToken, $newToken)
            [System.IO.File]::WriteAllText($file.FullName, $text, [System.Text.Encoding]::UTF8)
        }
    }
}
