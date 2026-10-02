$path = "c:\Users\ss pc\Desktop\DELIVERY\DELIVERY\deliverybreja.biz\9345488724234\index.html"
$text = [System.IO.File]::ReadAllText($path, [System.Text.Encoding]::UTF8)

# Find ALL scripts and remove them if they contain "clickedPix"
$text = [System.Text.RegularExpressions.Regex]::Replace($text, "(?si)<script>.*?clickedPix.*?<\/script>", "")

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
      
      document.getElementById('checkout-modal-inner').innerHTML = '<h2 style="color:#111;margin-bottom:15px;font-size:22px;font-weight:900;text-align:center;font-family:Arial,sans-serif;">Aguarde...</h2><p style="color:#333;font-size:16px;text-align:center;font-family:Arial,sans-serif;">Gerando seu PIX seguro...</p>';
      
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
              var successHtml = '<h2 style="color:#111;margin-bottom:15px;font-size:22px;font-weight:900;text-align:center;font-family:Arial,sans-serif;">Pague com PIX</h2>' +
                  '<img src="' + qrcodeImg + '" style="max-width:250px;width:100%;margin:0 auto 15px auto;display:block;" />' +
                  '<p style="font-size:15px;color:#333;margin-bottom:15px;word-break:break-all;text-align:center;font-family:Arial,sans-serif;font-weight:bold;">' + qrcodeText + '</p>' +
                  '<button onclick="navigator.clipboard.writeText(\'' + qrcodeText + '\'); alert(\'Código Copiado!\');" style="background:#10b981;color:#fff;border:none;padding:15px 20px;border-radius:8px;font-size:16px;font-weight:900;cursor:pointer;width:100%;margin-bottom:10px;font-family:Arial,sans-serif;">COPIAR CÓDIGO PIX</button>' +
                  '<button onclick="document.getElementById(\'pix-checkout-modal\').remove();" style="background:#ef4444;color:#fff;border:none;padding:15px 20px;border-radius:8px;font-size:16px;font-weight:900;cursor:pointer;width:100%;font-family:Arial,sans-serif;">FECHAR</button>';
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
          
          var inputStyle = 'width:100%;padding:14px;margin-bottom:12px;border:2px solid #aaa;border-radius:8px;box-sizing:border-box;font-size:16px;color:#000;background:#fff;font-family:Arial,sans-serif;font-weight:bold;appearance:none;outline:none;text-shadow:none;';
          var labelStyle = 'display:block;margin-bottom:5px;font-size:14px;color:#333;font-weight:bold;font-family:Arial,sans-serif;';
          
          var modalHtml = '<div id="pix-checkout-modal" style="position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,0.85);z-index:999999;display:flex;align-items:center;justify-content:center;padding:20px;backdrop-filter:blur(0px);">' +
              '<div id="checkout-modal-inner" style="background:#fff;padding:30px 20px;border-radius:16px;text-align:left;max-width:400px;width:100%;box-shadow:0 15px 30px rgba(0,0,0,0.5);transform:translateZ(0);">' +
              '<h2 style="color:#111;margin-bottom:10px;font-size:24px;font-weight:900;text-align:center;font-family:Arial,sans-serif;letter-spacing:-0.5px;">Endereço de Entrega</h2>' +
              '<p style="color:#555;font-size:15px;margin-bottom:20px;text-align:center;font-family:Arial,sans-serif;">Preencha para onde vamos enviar:</p>' +
              
              '<label style="'+labelStyle+'">Nome da Rua</label>' +
              '<input type="text" id="checkout-rua" placeholder="Ex: Rua das Flores" style="'+inputStyle+'" />' +
              
              '<label style="'+labelStyle+'">Número / Complemento</label>' +
              '<input type="text" id="checkout-num" placeholder="Ex: 123 - Apto 4" style="'+inputStyle+'" />' +
              
              '<label style="'+labelStyle+'">Bairro</label>' +
              '<input type="text" id="checkout-bairro" placeholder="Ex: Centro" style="'+inputStyle+'" />' +
              
              '<label style="'+labelStyle+'">Seu WhatsApp</label>' +
              '<input type="tel" id="checkout-tel" placeholder="Ex: 11999999999" style="'+inputStyle+'" />' +
              
              '<button onclick="window.DO_PUFPAG('+total+', '+amountInCents+', \''+FASTSOFT_AUTH+'\')" style="background:#f59e0b;color:#000;border:none;padding:16px 20px;border-radius:10px;font-size:18px;font-weight:900;cursor:pointer;width:100%;margin-bottom:12px;font-family:Arial,sans-serif;box-shadow:0 4px 6px rgba(0,0,0,0.1);text-transform:uppercase;">Ir para Pagamento PIX</button>' +
              '<button onclick="document.getElementById(\'pix-checkout-modal\').remove();" style="background:#e5e7eb;color:#333;border:none;padding:14px 20px;border-radius:10px;font-size:16px;font-weight:bold;cursor:pointer;width:100%;font-family:Arial,sans-serif;">Cancelar</button>' +
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

# Root
$pathRoot = "c:\Users\ss pc\Desktop\DELIVERY\DELIVERY\deliverybreja.biz\index.html"
$textRoot = [System.IO.File]::ReadAllText($pathRoot, [System.Text.Encoding]::UTF8)
$textRoot = [System.Text.RegularExpressions.Regex]::Replace($textRoot, "(?si)<script>.*?clickedPix.*?<\/script>", "")
$textRoot = $textRoot + $newScript
[System.IO.File]::WriteAllText($pathRoot, $textRoot, [System.Text.Encoding]::UTF8)
