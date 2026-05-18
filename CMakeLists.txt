cmake_minimum_required(VERSION 3.20)

# Toggle this to ON for Assembly, OFF for C
option(USE_ASM "Set to ON for Assembly, OFF for C" OFF)

if(USE_ASM)
    project(AVR_BareMetal ASM)
    add_executable(Indexer main.S)
else()
    project(AVR_BareMetal C)
    add_executable(Indexer main.c)
endif()