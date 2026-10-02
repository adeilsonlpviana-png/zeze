$path = "c:\Users\ss pc\Desktop\DELIVERY\DELIVERY\deliverybreja.biz\9345488724234\index.html"
$text = [System.IO.File]::ReadAllText($path, [System.Text.Encoding]::UTF8)

$oldScript = "var totalEl = document.querySelector('.text-amber-400.text-lg');
                if (!totalEl) {
                    alert('Carrinho vazio ou valor invlido para gerar PIX.');
                    return;
                }
                var totalText = totalEl.innerText || totalEl.textContent;
                var totalValue = parseFloat(totalText.replace(/[^\d,]/g, '').replace(',', '.'));"

$newScript = "var totalEls = document.querySelectorAll('.text-amber-400.text-lg');
                var totalValue = 0;
                for (var i = 0; i < totalEls.length; i++) {
                    var tText = totalEls[i].innerText || totalEls[i].textContent || '';
                    var val = parseFloat(tText.replace(/[^\d,]/g, '').replace(',', '.'));
                    if (val > 0) {
                        totalValue = val;
                        break;
                    }
                }"

if ($text.Contains("var totalEl = document.querySelector('.text-amber-400.text-lg');")) {
    # We replace the specific lines but since it has weird encodings in my hardcoded string, I will use regex or careful replacement
}
