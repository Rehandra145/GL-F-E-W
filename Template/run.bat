@echo off
g++ main.cpp -o bin/main.exe -Iinclude -Llib -lglfw3 -lglew32 -lopengl32 -lgdi32
bin\main.exe