DIR = .
BUILD = .
EXEC = $(BUILD)/prog
CC = gcc

# Paramètres compilateur

CPARAM = -Wall

# Listes des sources

SRC = $(wildcard $(DIR)/*.c)
HEADERS = $(wildcard $(DIR)/*.h)
OBJ = $(patsubst $(DIR)/%.c,$(BUILD)/%.o,$(SRC))

# Cibles

all: $(EXEC)

$(BUILD)/%.o: $(DIR)/%.c $(HEADERS)
	$(CC) -c $< -o $@ $(CPARAM)

$(EXEC): $(OBJ) | $(SAVEDIR)
	$(CC) $^ -o $@ $(CPARAM)

# Clean

clean:
	rm $(BUILD)/*.o
	rm $(EXEC)