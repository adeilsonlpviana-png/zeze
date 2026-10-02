const fs = require('fs');
const path = require('path');

const slug = '9345488724234';
const dir = path.join(process.cwd(), slug);

const replacements = [
    { from: '"/products/', to: '"/' + slug + '/products/' },
    { from: '"/_next/', to: '"/' + slug + '/_next/' },
    { from: '"/categoria/', to: '"/' + slug + '/categoria/' },
    { from: '"/produto/', to: '"/' + slug + '/produto/' },
    { from: '"/privacidade"', to: '"/' + slug + '/privacidade.html"' },
    { from: '"/termos"', to: '"/' + slug + '/termos.html"' },
    { from: '"/contato"', to: '"/' + slug + '/contato.html"' },
    { from: '"/trocas-devolucoes"', to: '"/' + slug + '/trocas-devolucoes.html"' }
];

function processDir(currentDir) {
    const entries = fs.readdirSync(currentDir, { withFileTypes: true });
    for (const entry of entries) {
        const fullPath = path.join(currentDir, entry.name);
        if (entry.isDirectory()) {
            processDir(fullPath);
        } else if (entry.isFile() && (entry.name.endsWith('.html') || entry.name.endsWith('.js'))) {
            let content = fs.readFileSync(fullPath, 'utf8');
            let modified = false;
            for (const r of replacements) {
                if (content.includes(r.from)) {
                    content = content.split(r.from).join(r.to);
                    modified = true;
                }
            }
            if (modified) {
                fs.writeFileSync(fullPath, content, 'utf8');
            }
        }
    }
}

processDir(dir);
console.log('Node.js replacement complete!');