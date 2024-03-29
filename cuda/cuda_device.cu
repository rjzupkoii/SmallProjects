/*
 * cuda_device.cu
 *
 * Demo code to get the number of CUDA devices attached.
 */
#include <cstdlib>
#include <stdio.h>

int main() {
    auto devices = 0;

    // Get the device count, check for an error
    auto error = cudaGetDeviceCount(&devices);
    if (error != cudaSuccess) {
        printf("%s\n", cudaGetErrorString(error));
        return EXIT_FAILURE;
    }

    // Print the properties for each device installed
    for (auto ndx = 0; ndx < devices; ndx++) {
        cudaDeviceProp properties;
        cudaGetDeviceProperties(&properties, ndx);
        printf("Device Number: %d\n", ndx);
        printf("  Device name: %s\n", properties.name);
        printf("  Memory Clock (Khz): %d\n", properties.memoryClockRate);
        printf("  Memory Bus Width (bits): %d\n", properties.memoryBusWidth);
        printf("  Peak Memory Bandwidth (GB/s): %.2f\n\n", 2.0 * properties.memoryClockRate * (properties.memoryBusWidth / 8) / 1.0e6);
    }

    return EXIT_SUCCESS;
}