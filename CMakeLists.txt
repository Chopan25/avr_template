cmake_minimum_required(VERSION 3.20)

# 1. THE FLAG: Change this to ON for Assembly, OFF for C.
option(USE_ASM "Set to ON to compile main.S, OFF to compile main.c" OFF)

if(USE_ASM)
    project(AVR_BareMetal ASM)
    set(SOURCE_FILE "main.S")
    # Assembly requires specific preprocessor flags
    set(COMPILER_ARGS "avr-gcc -g -mmcu=atmega328p -DF_CPU=16000000UL -x assembler-with-cpp -c ${SOURCE_FILE} -o main.o")
    message(STATUS "🛠️ Mode: BARE-METAL ASSEMBLY")
else()
    project(AVR_BareMetal C)
    set(SOURCE_FILE "main.c")
    # C requires size optimization (-Os)
    set(COMPILER_ARGS "avr-gcc -g -Os -mmcu=atmega328p -DF_CPU=16000000UL -c ${SOURCE_FILE} -o main.o")
    message(STATUS "🛠️ Mode: BARE-METAL C")
endif()

# Dummy target to force CLion to index the code for syntax highlighting
add_executable(Firmware_Indexer ${SOURCE_FILE})

# ---------------------------------------------------------
# CUSTOM TOOLCHAIN TARGETS (These replace your shell scripts)
# ---------------------------------------------------------

# Target 1: The Build Pipeline
add_custom_target(1_Build_Firmware
        COMMAND docker run --rm -v ${CMAKE_CURRENT_SOURCE_DIR}:/src -w /src avr-toolchain
        sh -c "${COMPILER_ARGS} && \
                   avr-gcc -mmcu=atmega328p main.o -o firmware.elf && \
                   avr-objcopy -O ihex -R .eeprom firmware.elf firmware.hex"
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        COMMENT "Compiling ${SOURCE_FILE} inside Docker..."
)

# Target 2: The Flasher
add_custom_target(2_Flash_Hardware
        COMMAND docker run --rm --device=/dev/ttyACM0:/dev/ttyACM0 -v ${CMAKE_CURRENT_SOURCE_DIR}:/src -w /src avr-toolchain
        avrdude -F -V -c arduino -p m328p -P /dev/ttyACM0 -b 115200 -U flash:w:firmware.hex:i
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        COMMENT "Flashing firmware.hex to physical Arduino..."
)

# Target 3: The Simulator
add_custom_target(3_Start_Simulator
        COMMAND docker run --rm -p 1234:1234 -v ${CMAKE_CURRENT_SOURCE_DIR}:/src -w /src avr-toolchain
        simavr -m atmega328p -f 16000000 -g firmware.elf
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        COMMENT "Starting simavr on port 1234..."
)