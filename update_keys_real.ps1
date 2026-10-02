$htmlFiles = @(Get-ChildItem -Path "c:\Users\ss pc\Desktop\DELIVERY\DELIVERY\deliverybreja.biz\9345488724234" -Recurse -Filter "*.html") + @(Get-ChildItem -Path "c:\Users\ss pc\Desktop\DELIVERY\DELIVERY\deliverybreja.biz" -Filter "*.html")

$oldToken1 = "Basic a3BfMzJmMzAwODg1MWM4ZDExOGNhM2U1MTI0YTQzNjhmOGZlZmU2MDRmYTg4NjU5ZTQ4MWE2YjgzZTA3ZDIyYmNkMzprc183MTUwNTc1YTUwNzZmYjNlZjQzODY1Nzk4NTg2NDIyMGIxNTM4M2E3NWE2MGIyN2YzZTYwNzk3MTQ0YzM3NmFh"
$oldToken2 = "Basic a3BfNzQ2NzBlYTA2YjQwMTFkNmQzNzk0MDhmNzg5MTg0MWIzYjljOWU2ZGFjZjQ4MDhhNzdmMTM1MDY4MTUwMGQ1Nzprc180ODI0YjVkODI5ZGMwNjc4ZjVlZmY4ZWJkNzAzN2YzYzI4MTVlOTgxYjVmN2I4NTI0NDRlNWMxODIxMmNiYjdl"
$newToken = "Basic a3BfYzI5NGU1NmFkNDJjOGRhOWU0MWViMTc0NDQwOWE2NWJmMDE0MWU2MDU3ZjYyZDU2YjM4N2JjZjBjMTJmZDJhNDprc180MTVjNjQ4MGRkNWNlZDBmM2JjNTc0ZmRjMDFjMjM1OTk0ZDI5ZDdmOWZhZjQ5ZjcyYzMxMDJkZTVjOTU4ZTQ3"

foreach ($file in $htmlFiles) {
    if ($file.FullName -match "\.html$") {
        $text = [System.IO.File]::ReadAllText($file.FullName, [System.Text.Encoding]::UTF8)
        $changed = $false
        
        if ($text.Contains($oldToken1)) {
            $text = $text.Replace($oldToken1, $newToken)
            $changed = $true
        }
        if ($text.Contains($oldToken2)) {
            $text = $text.Replace($oldToken2, $newToken)
            $changed = $true
        }
        
        if ($changed) {
            [System.IO.File]::WriteAllText($file.FullName, $text, [System.Text.Encoding]::UTF8)
        }
    }
}
