# Ambiente local da disciplina (Windows + MSYS2/MinGW64).
#
# Uso, no inicio de cada sessao de terminal:
#
#     source env.sh
#
# Depois disso a regra de build do professor funciona literalmente:
#
#     mkdir build && cd build && cmake .. && make && ./aula00_teste
#
# O que cada linha resolve:
#  - PATH             : poe o toolchain do MinGW64 na frente (g++, cmake, glslangValidator).
#  - CMAKE_GENERATOR  : sem isso o CMake escolhe Ninja e o "make" nao acha Makefile.
#  - funcao make      : no MinGW o executavel do make chama-se mingw32-make; o "make"
#                       do MSYS nao funciona com Makefiles do MinGW (ele abre o cmd.exe).
#                       Usamos funcao (e nao alias) porque alias nao vale dentro de scripts.

export PATH="/c/msys64/mingw64/bin:/c/msys64/usr/bin:$PATH"
export CMAKE_GENERATOR="MinGW Makefiles"
make() { mingw32-make "$@"; }
export -f make

echo "Ambiente Vulkan carregado:"
echo "  g++              $(g++ --version | head -1 | awk '{print $NF}')"
echo "  cmake            $(cmake --version | head -1 | awk '{print $3}')"
echo "  glslangValidator $(glslangValidator --version 2>&1 | head -1 | awk '{print $NF}')"
