#include "convolution.h"

void convolve(const float *image, float *output, std::size_t n,
              const float *mask, std::size_t m) {

    std::size_t offset = m / 2;

    for (std::size_t x = 0; x < n; x++) {
        for (std::size_t y = 0; y < n; y++) {

            float sum = 0.0f;

            for (std::size_t i = 0; i < m; i++) {
                for (std::size_t j = 0; j < m; j++) {

                    int image_x = static_cast<int>(x) +
                                  static_cast<int>(i) -
                                  static_cast<int>(offset);

                    int image_y = static_cast<int>(y) +
                                  static_cast<int>(j) -
                                  static_cast<int>(offset);

                    float image_value;

                    bool x_inside = image_x >= 0 &&
                                    image_x < static_cast<int>(n);

                    bool y_inside = image_y >= 0 &&
                                    image_y < static_cast<int>(n);

                    if (x_inside && y_inside) {
                        image_value = image[image_x * n + image_y];
                    }
                    else if (x_inside || y_inside) {
                        image_value = 1.0f;
                    }
                    else {
                        image_value = 0.0f;
                    }

                    sum += mask[i * m + j] * image_value;
                }
            }

            output[x * n + y] = sum;
        }
    }
}