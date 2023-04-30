cmake_minimum_required(VERSION 3.18...3.23)

set(PROJECT_NAME "SDL2_Lua_test")
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_OSX_ARCHITECTURES "arm64;x86_64")
set(CMAKE_OSX_DEPLOYMENT_TARGET 10.11)

project(
    ${PROJECT_NAME}
    VERSION 0.1
    LANGUAGES C CXX
)

add_executable(${PROJECT_NAME} MACOSX_BUNDLE src/main.cpp)

find_package(SDL2 REQUIRED)
find_package(Lua REQUIRED) 

target_include_directories(${PROJECT_NAME} PUBLIC
    ${SDL2_INCLUDE_DIRS}
    ${LUA_INCLUDE_DIR}
)

target_link_libraries(${PROJECT_NAME} PUBLIC SDL2::SDL2 ${LUA_LIBRARY})
