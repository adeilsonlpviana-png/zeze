import os
import glob

slug = '9345488724234'

replacements = {
    '"/products/': '"/' + slug + '/products/',
    '"/_next/': '"/' + slug + '/_next/',
    '"/categoria/': '"/' + slug + '/categoria/',
    '"/produto/': '"/' + slug + '/produto/',
    '"/privacidade"': '"/' + slug + '/privacidade.html"',
    '"/termos"': '"/' + slug + '/termos.html"',
    '"/contato"': '"/' + slug + '/contato.html"',
    '"/trocas-devolucoes"': '"/' + slug + '/trocas-devolucoes.html"',
    'Ã§': 'ç',
    'Ã£': 'ã',
    'Ãµ': 'õ',
    'Ã¡': 'á',
    'Ã©': 'é',
    'Ã­': 'í',
    'Ã³': 'ó',
    'Ãº': 'ú',
    'Ã¢': 'â',
    'Ãª': 'ê',
    'Ã´': 'ô',
    'Ã ': 'à',
    'Ã‡': 'Ç',
    'Ãƒ': 'Ã',
    'Ã•': 'Õ',
    'Ã ': 'Á',
    'Ã‰': 'É',
    'Ã ': 'Í',
    'Ã“': 'Ó',
    'Ãš': 'Ú',
    'Â·': '·',
    'â†’': '→',
    'Â©': '©',
    'â€”': '—',
    'â€œ': '“',
    'â€ ': '”',
    'alcoÃ³licas': 'alcoólicas',
    'moderaÃ§Ã£o': 'moderação',
    'preÃ§os': 'preços',
    'condiÃ§Ãµes': 'condições',
    'cartÃ£o': 'cartão',
    'crÃ©dito': 'crédito',
    'criptografada': 'criptografada',
    'polÃ\xadticas': 'políticas',
    'disponÃ\xadveis': 'disponíveis',
    'PÃ¡gina': 'Página',
    'visÃ\xadveis': 'visíveis',
    'InformaÃ§Ãµes': 'Informações',
    'regiÃ£o': 'região',
    'transparÃªncia': 'transparência'
}

for root, _, files in os.walk(slug):
    for f in files:
        if f.endswith('.html') or f.endswith('.js'):
            path = os.path.join(root, f)
            with open(path, 'r', encoding='utf-8', errors='ignore') as file:
                content = file.read()
            
            modified = False
            for k, v in replacements.items():
                if k in content:
                    content = content.replace(k, v)
                    modified = True
            
            if modified:
                with open(path, 'w', encoding='utf-8') as file:
                    file.write(content)

print('Python fix complete!')