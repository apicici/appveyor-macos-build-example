LUA_VERSION=5.4.4
export MACOSX_DEPLOYMENT_TARGET=10.11

mkdir -p "$HOME/Library/Frameworks"

mkdir tmp
cd tmp

# dowload and build universal dylib for Lua, following https://blog.spreendigital.de/2015/01/22/how-to-compile-lua-5-3-0-as-a-mac-os-x-dynamic-library/
curl -L https://www.lua.org/ftp/lua-${LUA_VERSION}.tar.gz --output lua-${LUA_VERSION}.tar.gz
tar zxf lua-${LUA_VERSION}.tar.gz
cd lua-${LUA_VERSION}
make macosx MYCFLAGS="-arch x86_64 -arch arm64"
echo 'liblua.dylib: $(CORE_O) $(LIB_O)' >> src/makefile
echo -e '\t$(CC) -dynamiclib -o $@ $^ $(LIBS) -arch x86_64 -arch arm64 -install_name @rpath/$@' >> src/makefile
make -C src liblua.dylib
cp src/*.{h,hpp,dylib} "$HOME/Library/Frameworks/"
cd ..

# download SDL2.framework
curl -L https://github.com/libsdl-org/SDL/releases/download/release-2.26.5/SDL2-2.26.5.dmg --output SDL2-2.26.5.dmg
hdiutil attach SDL2-2.26.5.dmg
cp -a /Volumes/SDL2/SDL2.framework "$HOME/Library/Frameworks/SDL2.framework"

# build application
cd ..
mkdir build
cd build
cmake ..
make

# set rpath to bundle Lua and SDL2 with the executable inside the app bundle
install_name_tool -add_rpath @executable_path SDL2_Lua_test.app/Contents/MacOS/SDL2_Lua_test
cp -a "$HOME/Library/Frameworks/SDL2.framework" SDL2_Lua_test.app/Contents/MacOS/
cp -a "$HOME/Library/Frameworks/"*.dylib SDL2_Lua_test.app/Contents/MacOS/

#push artifact
zip -r SDL2_Lua_test.zip SDL2_Lua_test.app
appveyor PushArtifact SDL2_Lua_test.zip
