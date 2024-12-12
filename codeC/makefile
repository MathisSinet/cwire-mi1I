DIR = .
BUILD = .
EXEC = $(BUILD)/prog
CC = gcc

# Paramètres compilateur

CPARAM = -Wall

# Source list

SRC = $(wildcard $(DIR)/*.c)
HEADERS = $(wildcard $(DIR)/*.h)
OBJ = $(patsubst $(DIR)/%.c,$(BUILD)/%.o,$(SRC))

# Cibles

all: $(EXEC)

$(BUILD)/%.o: $(DIR)/%.c $(HEADERS)
	$(CC) -c $< -o $@ $(CFLAGS)

$(EXEC): $(OBJ) | $(SAVEDIR)
	$(CC) $^ -o $@ $(CFLAGS)

# Clean

clean:
	rm $(BUILD)/*.o
	rm $(EXEC)