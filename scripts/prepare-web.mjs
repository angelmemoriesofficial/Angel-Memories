import { mkdir, copyFile } from 'node:fs/promises';

const files = ['index.html', 'logo.png', 'hero.png', 'hero2.png'];
await mkdir('www', { recursive: true });
for (const file of files) {
  await copyFile(file, `www/${file}`);
}
console.log('Prepared Angel Memories web assets in www/.');
