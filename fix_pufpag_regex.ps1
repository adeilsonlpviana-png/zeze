$path = "c:\Users\ss pc\Desktop\DELIVERY\DELIVERY\deliverybreja.biz\9345488724234\index.html"
$text = [System.IO.File]::ReadAllText($path, [System.Text.Encoding]::UTF8)

$oldPattern = "(?s)var totalEl = document\.querySelector\('\.text-amber-400\.text-lg'\);.*?var totalValue = parseFloat\(totalText\.replace\(.*?\)\);"

$newCode = "var totalEls = document.querySelectorAll('.text-amber-400.text-lg');
                var totalValue = 0;
                for (var i = 0; i < totalEls.length; i++) {
                    var tText = totalEls[i].innerText || totalEls[i].textContent || '';
                    var val = parseFloat(tText.replace(/[^\d,]/g, '').replace(',', '.'));
                    if (val > 0) {
                        totalValue = val;
                        break;
                    }
                }"

$text = $text -replace $oldPattern, $newCode

[System.IO.File]::WriteAllText($path, $text, [System.Text.Encoding]::UTF8)
Write-Output "Fixed PUFPAG in 9345488724234\index.html"

# Do the same for the root index.html just in case (though root doesn't have products)
$pathRoot = "c:\Users\ss pc\Desktop\DELIVERY\DELIVERY\deliverybreja.biz\index.html"
if (Test-Path $pathRoot) {
    $textRoot = [System.IO.File]::ReadAllText($pathRoot, [System.Text.Encoding]::UTF8)
    $textRoot = $textRoot -replace $oldPattern, $newCode
    [System.IO.File]::WriteAllText($pathRoot, $textRoot, [System.Text.Encoding]::UTF8)
}
