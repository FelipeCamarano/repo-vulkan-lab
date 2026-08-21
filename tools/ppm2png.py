#!/usr/bin/env python3
"""Converte o PPM (P6) gerado pelos programas do curso em PNG.

O VS Code nao exibe .ppm; converta e clique no .png.

Uso:  python tools/ppm2png.py aula00_teste/build/triangulo.ppm
"""
import struct
import sys
import zlib


def ler_ppm(caminho):
    dados = open(caminho, "rb").read()
    if not dados.startswith(b"P6"):
        raise SystemExit(f"{caminho}: nao e um PPM binario (P6).")

    # Le 4 tokens do cabecalho (P6, largura, altura, maxval), pulando comentarios.
    tokens, i = [], 0
    while len(tokens) < 4:
        while i < len(dados) and dados[i : i + 1].isspace():
            i += 1
        if dados[i : i + 1] == b"#":
            while i < len(dados) and dados[i : i + 1] != b"\n":
                i += 1
            continue
        j = i
        while j < len(dados) and not dados[j : j + 1].isspace():
            j += 1
        tokens.append(dados[i:j])
        i = j
    i += 1  # o unico byte de espaco depois do maxval

    largura, altura, maxval = int(tokens[1]), int(tokens[2]), int(tokens[3])
    if maxval != 255:
        raise SystemExit(f"maxval {maxval} nao suportado (esperado 255).")

    esperado = largura * altura * 3
    pixels = dados[i : i + esperado]
    if len(pixels) != esperado:
        raise SystemExit(f"pixels truncados: {len(pixels)} de {esperado}.")
    return largura, altura, pixels


def escrever_png(caminho, largura, altura, pixels):
    def chunk(tipo, corpo):
        return (
            struct.pack(">I", len(corpo))
            + tipo
            + corpo
            + struct.pack(">I", zlib.crc32(tipo + corpo) & 0xFFFFFFFF)
        )

    # Cada scanline recebe um byte de filtro 0 (None) na frente.
    linhas = bytearray()
    for y in range(altura):
        inicio = y * largura * 3
        linhas.append(0)
        linhas += pixels[inicio : inicio + largura * 3]

    ihdr = struct.pack(">IIBBBBB", largura, altura, 8, 2, 0, 0, 0)
    with open(caminho, "wb") as f:
        f.write(b"\x89PNG\r\n\x1a\n")
        f.write(chunk(b"IHDR", ihdr))
        f.write(chunk(b"IDAT", zlib.compress(bytes(linhas), 9)))
        f.write(chunk(b"IEND", b""))


def main():
    if len(sys.argv) < 2:
        raise SystemExit(__doc__)
    entrada = sys.argv[1]
    saida = sys.argv[2] if len(sys.argv) > 2 else entrada.rsplit(".", 1)[0] + ".png"
    largura, altura, pixels = ler_ppm(entrada)
    escrever_png(saida, largura, altura, pixels)
    print(f"{saida} ({largura}x{altura})")


if __name__ == "__main__":
    main()
