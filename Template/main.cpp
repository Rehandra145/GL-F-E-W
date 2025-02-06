//if your vscode showing eror in include tag, try to compile it manualy, if you dont know how to do it, just ask me
//if you want to run this code, you need to install glfw and glew first then edit your system environment variable
//if you dont know how to install it, just ask me
//cpp intellicence is not working in this file, so you need to write the code manually
//if you want to use intellicence, just create new file and copy paste the code
//if you have any question, just ask me
//vs code ekstension is suck


//mandatory lib (dont delete this pls)
#include <glew.h> //again, dont delete this shit if you dont want to cry in the middle of the night
#include <glfw3.h> //and this too
#include <iostream>

//additional lib
#include <cmath>



//you can start to code right here

const int SEGMENTS = 100;
const float PI = 3.14159265359;

bool showText = true;
double lastTime = 0.0;
double blinkInterval = 0.5;

// Variabel untuk aspect ratio
float aspectRatio = 1.0f;

void framebuffer_size_callback(GLFWwindow*window, int width, int height) {
    glViewport(0, 0, width, height);
    aspectRatio = (float)width / (float)height;
}


void drawCircle(float cx, float cy, float radius, float r, float g, float b) {
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrtho(-aspectRatio, aspectRatio, -1.0f, 1.0f, -1.0f, 1.0f);
    
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    
    glColor3f(r, g, b);
    glBegin(GL_TRIANGLE_FAN);
    glVertex2f(cx, cy);
    for (int i = 0; i <= SEGMENTS; i++) {
        float angle = 2.0f * PI * i / SEGMENTS;
        float x = cx + radius * cos(angle);
        float y = cy + radius * sin(angle);
        glVertex2f(x, y);
    }
    glEnd();
}

void drawText(float startY) {
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrtho(-aspectRatio, aspectRatio, -1.0f, 1.0f, -1.0f, 1.0f);
    
    glMatrixMode(GL_MODELVIEW);
    glLoadIdentity();
    
    glColor3f(1.0f, 1.0f, 1.0f);
    float charWidth = 0.05f;
    float charHeight = 0.1f;
    float charSpacing = 0.02f;
    
    float totalWidth = (3 * charWidth) + (2 * charSpacing);
    float x = -totalWidth/2.0f;
    float y = startY;

    glBegin(GL_LINES);
    glVertex2f(x, y + charHeight); glVertex2f(x + charWidth, y + charHeight);
    glVertex2f(x + charWidth/2, y + charHeight); glVertex2f(x + charWidth/2, y);
    glEnd();
    x += charWidth + charSpacing;

    glBegin(GL_LINES);
    glVertex2f(x, y + charHeight); glVertex2f(x, y);
    glVertex2f(x, y + charHeight); glVertex2f(x + charWidth, y + charHeight);
    glVertex2f(x, y + charHeight/2); glVertex2f(x + charWidth, y + charHeight/2);
    glVertex2f(x, y); glVertex2f(x + charWidth, y);
    glEnd();
    x += charWidth + charSpacing;

    glBegin(GL_LINE_STRIP);
    glVertex2f(x + charWidth, y + charHeight);
    glVertex2f(x, y + charHeight);
    glVertex2f(x, y + charHeight/2);
    glVertex2f(x + charWidth, y + charHeight/2);
    glVertex2f(x + charWidth, y);
    glVertex2f(x, y);
    glEnd();
}

int main() {
    if (!glfwInit()) {
        std::cerr << "Failed to initialize GLFW" << std::endl;
        return -1;
    }

    GLFWwindow* window = glfwCreateWindow(800, 600, "Eye Simulation with Blinking Text", NULL, NULL);
    if (!window) {
        std::cerr << "Failed to create GLFW window" << std::endl;
        glfwTerminate();
        return -1;
    }
    
    glfwMakeContextCurrent(window);
    glfwSetFramebufferSizeCallback(window, framebuffer_size_callback);

    if (glewInit() != GLEW_OK) {
        std::cerr << "Failed to initialize GLEW" << std::endl;
        return -1;
    }

    int width, height;
    glfwGetFramebufferSize(window, &width, &height);
    framebuffer_size_callback(window, width, height);

    while (!glfwWindowShouldClose(window)) {
        double currentTime = glfwGetTime();
        if (currentTime - lastTime >= blinkInterval) {
            showText = !showText;
            lastTime = currentTime;
        }

        glClear(GL_COLOR_BUFFER_BIT);

        drawCircle(0.0f, 0.2f, 0.4f, 1.0f, 1.0f, 1.0f);
        drawCircle(0.0f, 0.2f, 0.2f, 0.2f, 0.3f, 1.0f);
        drawCircle(0.0f, 0.2f, 0.08f, 0.0f, 0.0f, 0.0f);

        if (showText) {
            drawText(-0.4f);
        }

        glfwSwapBuffers(window);
        glfwPollEvents();
    }

    glfwDestroyWindow(window);
    glfwTerminate();
    return 0;
}