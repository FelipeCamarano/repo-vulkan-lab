# Aula 00 — Teste de ambiente

Valida que o ambiente Vulkan está funcionando. Renderiza um triângulo com Vulkan
e grava o resultado em `triangulo.ppm`.

> **Duas surpresas do código do professor:** ele renderiza *offscreen* (não abre
> janela — a apostila fala em "janela preta", mas o resultado é um arquivo), e o
> triângulo sai **vermelho**, não branco (o fragment shader devolve
> `vec4(1,0,0,1)`).

## Build e execução

```bash
source ../env.sh
```

```bash
mkdir build && cd build && cmake .. && make && ./aula00_teste.exe
```

Saída esperada:

```
tri.vert
tri.frag
✓ triangulo.ppm gerado!
```

As duas primeiras linhas são o `glslangValidator` compilando os shaders GLSL para
SPIR-V — o programa faz isso em tempo de execução, via `system()`.

## Ver a imagem

```bash
python ../../tools/ppm2png.py triangulo.ppm
```

Depois clique no `triangulo.png` gerado.

## Exercício para entregar

Alterar este programa para **mover o triângulo usando `glm::translate`**,
aplicando a translação **(0.5, 0)** — a mesma do exercício de papel da seção 5.5
da apostila.

Entrega:
1. o `main.cpp` modificado;
2. um screenshot do terminal mostrando a compilação/execução com o triângulo
   movido.

### Por onde começar

O `CMakeLists.txt` já linka a GLM — basta incluir:

```cpp
#include <glm/glm.hpp>
#include <glm/gtc/matrix_transform.hpp>

// Matriz identidade 4x4, transladada 0.5 para a direita:
glm::mat4 modelo = glm::translate(glm::mat4(1.0f), glm::vec3(0.5f, 0.0f, 0.0f));
```

Atenção a um detalhe que a apostila não menciona: **o vertex shader deste
programa não recebe matriz nenhuma** — ele repassa `inPos` direto (linhas 14–17).
Push constants só entram na Aula 2. Então, nesta aula, a translação é aplicada
**na CPU**: transforme cada vértice do array `vertices[]` (linha ~354) antes do
`memcpy` para o vertex buffer (linha ~393).

Cada vértice é `(x, y)`; para multiplicar pela matriz 4×4, monte um
`glm::vec4(x, y, 0.0f, 1.0f)` — o `w = 1` é o que habilita a translação.

Lembre da ordem: com vetores coluna, `M * v` lê-se da direita para a esquerda.

### Conferindo o resultado

O triângulo original tem base de x=80 a x=719 na imagem. Com a translação de
+0.5 em NDC (metade da largura da tela para a direita), a base deve ir para
x=280 a x=919 — ou seja, a ponta direita sai da tela.
