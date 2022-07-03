#######################################################
# Project Name (Basis for output file name)
#######################################################
PROJECT		:= PGECursor

#######################################################
# directory structure
#######################################################
ASSETS		:= assets
BIN         := bin
INC         := include
LIB         := lib
OBJ			:= obj
RES         := res
SRC         := src

inc_flag    := -I$(INC)
lib_flag    := -L$(LIB)

#######################################################
# symbol generation / optimization 
#######################################################
release_mode		:= -O2
debug_mode			:= -ggdb3 -Og

#######################################################
# C++ Source Files
#######################################################
cpp_sources		:= $(wildcard $(SRC)/*.cpp)

#######################################################
# linux dependent stuff
#######################################################
LINUX_CXX		:= g++

# executable output
linux_output	:= $(BIN)/$(PROJECT)

# static link options
linux_static_link	:= -Bstatic -static-libgcc -static-libstdc++
# shared link options
linux_shared_link	:= -static-libstdc++

# flags
linux_cflags		:= -std=c++17 $(release_mode) $(linux_static_link)

# libraries
linux_libraries		:= -lX11 -lGL -lpthread -lpng -lstdc++fs 

# object files derived from source files
linux_objects	:= $(patsubst $(SRC)/%,$(OBJ)/%,$(cpp_sources:.cpp=.linux_x86_64.o))


#######################################################
# windows dependent stuff
#######################################################
WIN_CXX         := i686-w64-mingw32-g++

windows_output	:= $(BIN)/$(PROJECT).exe

# static link options
windows_static_link	:= -Bstatic -static-libgcc -static-libstdc++ -static -s
# shared link options
windows_shared_link	:= -static-libstdc++ -s

# flags
windows_cflags			:= -std=c++17 $(release_mode) $(windows_static_link)

# libraries
windows_libraries	:= -luser32 -lgdi32 -lopengl32 -lgdiplus -lshlwapi -ldwmapi -lstdc++fs

# object files derived from source files
windows_objects	:= $(patsubst $(SRC)/%,$(OBJ)/%,$(cpp_sources:.cpp=.win_x86_64.o))

#######################################################
# emscripten dependent stuff
#######################################################
EM_CXX			:= em++

em_output		:= $(BIN)/$(PROJECT).html

# flags
em_cflags		:= -std=c++17 $(release_mode)
em_lflags		:= --preload-file $(ASSETS) -s ALLOW_MEMORY_GROWTH=1

# libraries
em_libraries	:= -s MAX_WEBGL_VERSION=2 -s MIN_WEBGL_VERSION=2 -s USE_LIBPNG=1

# object files derived from source files
em_objects		:= $(patsubst $(SRC)/%,$(OBJ)/%,$(cpp_sources:.cpp=.wasm.o))

#######################################################
# mac dependent stuff
#######################################################
MAC_CXX			:= clang++

mac_output		:= $(BIN)/$(PROJECT).app

# flags
mac_cflags		:= -arch x86_64 -std=c++17
mac_lflags		:= 

# libraries
mac_libraries	:= -framework OpenGL -framework GLUT -framework Carbon -lpng

# object files derived from source files
mac_objects		:= $(patsubst $(SRC)/%,$(OBJ)/%,$(cpp_sources:.cpp=.mac.o))



#######################################################
# finally, the build recipes!
#######################################################
.PHONY: linux windows emscripten clean

linux: $(linux_output)

windows: $(windows_output)

emscripten: $(em_output)

mac: $(mac_output)

# linux compile units
$(OBJ)/%.linux_x86_64.o : $(SRC)/%.cpp
	$(LINUX_CXX) $(linux_cflags) $(inc_flag) -c -o $@ $<

# link linux executable
$(linux_output) : $(linux_objects)
	$(LINUX_CXX) $(linux_cflags) -o $(linux_output) $^ $(linux_libraries) $(lib_flag)

# windows compile units
$(OBJ)/%.win_x86_64.o : $(SRC)/%.cpp
	$(WIN_CXX) $(windows_cflags) $(inc_flag) -c -o $@ $<

# link windows executable
$(windows_output) : $(windows_objects)
	$(WIN_CXX) $(windows_cflags) -o $(windows_output) $^ $(windows_libraries) $(lib_flag)

# emscripten compile units
$(OBJ)/%.wasm.o : $(SRC)/%.cpp
	$(EM_CXX) $(em_cflags) $(inc_flag) -c -o $@ $<
	
# link windows executable
$(em_output) : $(em_objects)
	@echo $(em_objects)
	$(EM_CXX) $(em_cflags) -o $(em_output) $^ $(em_lflags) $(em_libraries) $(lib_flag)

# emscripten compile units
$(OBJ)/%.mac.o : $(SRC)/%.cpp
	$(MAC_CXX) $(mac_cflags) $(inc_flag) -c -o $@ $<
	
# link windows executable
$(mac_output) : $(mac_objects)
	$(MAC_CXX) $(mac_cflags) -o $(mac_output) $^ $(mac_lflags) $(mac_libraries) $(lib_flag)

# remove executables and object files
clean:
	rm -rf $(BIN)/* $(OBJ)/*.o
