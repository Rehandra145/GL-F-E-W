#include <glew.h>
#include <glfw3.h>
#include <math.h>
#include <stdio.h>

#define NUM_POINTS 100

void errorCallback(int error, const char* description) {
    fprintf(stderr, "Error: %s\n", description);
}

int main() {
    // Inisialisasi GLFW
    if (!glfwInit()) {
        fprintf(stderr, "Gagal menginisialisasi GLFW\n");
        return -1;
    }

    glfwSetErrorCallback(errorCallback);

    // Membuat window
    GLFWwindow* window = glfwCreateWindow(800, 800, "Lingkaran Basic GLEW", NULL, NULL);
    if (!window) {
        fprintf(stderr, "Gagal membuat window\n");
        glfwTerminate();
        return -1;
    }

    glfwMakeContextCurrent(window);

    // Inisialisasi GLEW
    GLenum err = glewInit();
    if (GLEW_OK != err) {
        fprintf(stderr, "Error: %s\n", glewGetErrorString(err));
        glfwTerminate();
        return -1;
    }

    // Main loop
    while (!glfwWindowShouldClose(window)) {
        // Set viewport dan clear buffer
        int width, height;
        glfwGetFramebufferSize(window, &width, &height);
        glViewport(0, 0, width, height);
        glClearColor(1.0f, 1.0f, 1.0f, 1.0f);
        glClear(GL_COLOR_BUFFER_BIT);

        // Gambar lingkaran
        glColor3f(1.0f, 0.0f, 0.0f); // Warna merah
        glBegin(GL_POLYGON);
        for(int i = 0; i < NUM_POINTS; i++) {
            float angle = 2.0f * M_PI * i / NUM_POINTS;
            float x = 0.5f * cosf(angle);
            float y = 0.5f * sinf(angle);
            glVertex2f(x, y);
        }
        glEnd();

        // Swap buffers dan poll events
        glfwSwapBuffers(window);
        glfwPollEvents();

        // Check ESC key untuk keluar
        if (glfwGetKey(window, GLFW_KEY_ESCAPE) == GLFW_PRESS)
            glfwSetWindowShouldClose(window, GLFW_TRUE);
    }

    // Cleanup
    glfwDestroyWindow(window);
    glfwTerminate();
    return 0;
}