const fs = require('fs');
const buffer = fs.readFileSync('test_raw.html');
let isUtf8 = true;
try {
    const str = buffer.toString('utf8');
    if (str.includes('\ufffd')) {
        isUtf8 = false;
        console.log('Contains replacement characters! Not valid UTF8.');
    }
} catch (e) {
    isUtf8 = false;
}
if (isUtf8) console.log('Valid UTF-8');