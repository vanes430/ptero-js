# 🚀 Pterodactyl Multi-Runtime JS Image

### Node.js (18 / 20 / 22 / 24) + Bun + NVM + Yarn + PNPM

A lightweight JavaScript runtime image for **Pterodactyl Wings**, with
support for multiple Node.js versions and Bun.

------------------------------------------------------------------------

## 🌍 English -- Usage Guide

### 🟦 Switch Node Version

Inside your Pterodactyl **STARTUP** field, you can choose any installed
Node version:

``` bash
nvm use 18 && node index.js
```

``` bash
nvm use 20 && npm start
```

``` bash
nvm use 22 && yarn dev
```

``` bash
nvm use 24 && pnpm start
```

### 🟦 Use Bun

``` bash
bun run index.js
```

### 🟦 Build Docker Image Manually

``` bash
docker build -t ptero-js .
```

------------------------------------------------------------------------

## 🇮🇩 Indonesia -- Panduan Penggunaan

### 🟩 Ganti Versi Node.js

Di bagian **STARTUP** Pterodactyl, kamu bisa memilih versi Node apa pun:

``` bash
nvm use 18 && node index.js
```

``` bash
nvm use 20 && npm start
```

``` bash
nvm use 22 && yarn dev
```

``` bash
nvm use 24 && pnpm start
```

### 🟩 Pakai Bun

``` bash
bun run index.js
```

### 🟩 Build image Docker (opsional)

``` bash
docker build -t ptero-js .
```

------------------------------------------------------------------------

## ❤️ Credits

Simple multi-runtime JS environment for Pterodactyl.
