PROJECT     := PGECursor.exe
# PROJECT     := PGECursor

RELEASE     := -O3
DEBUG       := -ggdb3 -Og
STATIC      := -Bstatic -static-libgcc -static-libstdc++ -static
# STATIC      := -Bstatic -static-libgcc -static-libstdc++
SHARED      := -static-libstdc++

BUILD       := $(DEBUG)
# BUILD      := $(RELEASE)

LINKTYPE    := $(STATIC)
#LINKTYPE   := $(SHARED)

CXX_FLAGS   := -std=c++17 $(BUILD) $(LINKTYPE)
CXX         := i686-w64-mingw32-g++
# CXX         := g++

BIN         := bin
SRC         := src
INC         := include
LIB         := lib
OBJ         := obj
RES         := res

INC_FLAG    := -I$(INC)
LIB_FLAG    := -L$(LIB)

LIBRARIES   := -luser32 -lgdi32 -lopengl32 -lgdiplus -lshlwapi -ldwmapi -lstdc++fs
# LIBRARIES   := -lX11 -lGL -lpthread -lpng -lstdc++fs 

SOURCES     := $(wildcard $(SRC)/*.cpp)
OBJECTS     := $(patsubst $(SRC)/%,$(OBJ)/%,$(SOURCES:.cpp=.o))

.PHONY: clean all

all: $(BIN)/$(PROJECT)

# Compile only
$(OBJ)/%.o : $(SRC)/%.cpp $(DEPENDENCIES)
	$(CXX) $(CXX_FLAGS) $(INC_FLAG) -c -o $@ $<

# Link the object files and libraries
$(BIN)/$(PROJECT) : $(OBJECTS)
	$(CXX) $(CXX_FLAGS) -o $(BIN)/$(PROJECT) $^ $(LIBRARIES) $(LIB_FLAG)

# .PHONY: clean

clean:
	rm -rf $(BIN)/$(PROJECT) $(OBJ)/*.o
