#include "SDL2/SDL.h"
#include "lua.hpp"

int main(int argc, char *argv[])
{
    lua_State *L = luaL_newstate();
    luaL_openlibs(L);
    luaL_dostring(L, "print('Lua is working')");
    lua_close(L);

    if (SDL_Init(SDL_INIT_EVERYTHING) != 0) {
        printf("error initializing SDL: %s\n", SDL_GetError());
    }
    SDL_Window* window = SDL_CreateWindow("Test",
                                          SDL_WINDOWPOS_CENTERED,
                                          SDL_WINDOWPOS_CENTERED,
                                          100, 100, 0);
 
    int close = false;
 
    while (!close) {
        SDL_Event event;
 
        while (SDL_PollEvent(&event)) {
            if (event.type == SDL_QUIT) {
                close = true;
            }
        }
        SDL_Delay(100);
    }
 
    SDL_DestroyWindow(window);
    SDL_Quit();
    return 0;
}

