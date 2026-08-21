#!/usr/bin/env bash
# Instala o ambiente Vulkan da disciplina no Windows, via MSYS2.
#
# Pre-requisito: MSYS2 instalado em C:\msys64 (https://www.msys2.org).
# Rode UMA VEZ:  bash setup_windows.sh
set -euo pipefail

PACMAN="/c/msys64/usr/bin/pacman.exe"
[ -x "$PACMAN" ] || { echo "ERRO: MSYS2 nao encontrado em C:\msys64."; exit 1; }

echo ">>> Sincronizando a base de pacotes..."
"$PACMAN" -Sy --noconfirm

echo ">>> Instalando toolchain + Vulkan + GLM..."
"$PACMAN" -S --needed --noconfirm \
    mingw-w64-x86_64-gcc \
    mingw-w64-x86_64-cmake \
    mingw-w64-x86_64-make \
    mingw-w64-x86_64-jsoncpp \
    mingw-w64-x86_64-vulkan-headers \
    mingw-w64-x86_64-vulkan-loader \
    mingw-w64-x86_64-vulkan-validation-layers \
    mingw-w64-x86_64-glslang \
    mingw-w64-x86_64-spirv-tools \
    mingw-w64-x86_64-glm

export PATH="/c/msys64/mingw64/bin:/c/msys64/usr/bin:$PATH"

echo ""
echo ">>> Validando:"
vulkaninfo --summary 2>/dev/null | grep -E "deviceName|driverName" || echo "AVISO: vulkaninfo nao listou dispositivo."
cmake --version | head -1
glslangValidator --version 2>&1 | head -1

echo ""
echo ">>> Pronto. Agora rode:  source env.sh"
