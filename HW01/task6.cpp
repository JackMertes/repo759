#include <cstdio>
#include <cstdlib>
#include <iostream>

int main(int argc, char *argv[]) {
    int N = atoi(argv[1]);

    for (int i = 0; i <= N; i++) {
        if (i > 0) printf(" ");
        printf("%d", i);
    }
    printf("\n");

    for (int i = N; i >= 0; i--) {
        if (i < N) std::cout << " ";
        std::cout << i;
    }
    std::cout << "\n";

    return 0;
}