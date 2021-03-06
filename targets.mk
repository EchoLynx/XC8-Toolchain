# **************************************************************************** #
# Primary targets
	
# Build the project
compile: venv $(PROJECT_HEX)

# Upload the hex file to the target device
upload: venv $(PROJECT_HEX) 
	$(VENV_PYTHON) $(TOOLCHAIN_DIR)/scripts/upload.py

# Remove the compiler outputs
clean:
ifeq ($(OS),Windows_NT)
	del /s /q $(BUILD_DIR)\* 1>nul
	del /s /q $(OBJ_DIR)\* 1>nul
else
	rm -rf $(BUILD_DIR)/*
	rm -rf $(OBJ_DIR)/*
endif

# Run cog to perform in-line code generation
.PHONY: cog
cog: venv
	$(VENV_PYTHON) -m cogapp -Iscripts -p "import cogutils as utils" @cogfiles.txt 
	rm -rf ./src/__pycache__

# generate doxygen output
docs:
	doxygen Doxyfile
	
# run cppcheck
lint: venv
	$(VENV_PYTHON) scripts/cppcheck.py	