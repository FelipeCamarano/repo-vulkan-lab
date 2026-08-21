cmake_minimum_required(VERSION 3.16)
project(aula00_teste LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Vulkan: vem do pacote libvulkan-dev
find_package(Vulkan REQUIRED)

add_executable(aula00_teste main.cpp)
target_link_libraries(aula00_teste PRIVATE Vulkan::Vulkan)

# GLM: header-only, vem do pacote libglm-dev.
# Versoes novas trazem glmConfig.cmake; as antigas so instalam os headers.
find_package(glm QUIET)
if(glm_FOUND)
    target_link_libraries(aula00_teste PRIVATE glm::glm)
    message(STATUS "GLM encontrado via find_package.")
else()
    find_path(GLM_INCLUDE_DIR glm/glm.hpp)
    if(GLM_INCLUDE_DIR)
        target_include_directories(aula00_teste PRIVATE ${GLM_INCLUDE_DIR})
        message(STATUS "GLM encontrado em: ${GLM_INCLUDE_DIR}")
    else()
        message(WARNING "GLM nao encontrado. Rode: sudo apt-get install -y libglm-dev")
    endif()
endif()

# Aviso em tempo de build se o compilador de shaders faltar.
find_program(GLSLANG_VALIDATOR glslangValidator)
if(NOT GLSLANG_VALIDATOR)
    message(WARNING "glslangValidator nao encontrado. Rode: sudo apt-get install -y glslang-tools")
endif()
