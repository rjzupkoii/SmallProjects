# CUDA Projects

## Installing CUDA

This is based upon the [guidelines for the latest driver](https://developer.nvidia.com/cuda-downloads) on Debian 12.

First, install the base files for the distribution:

```bash
wget https://developer.download.nvidia.com/compute/cuda/repos/debian12/x86_64/cuda-keyring_1.1-1_all.deb
sudo dpkg -i cuda-keyring_1.1-1_all.deb
sudo add-apt-repository contrib
sudo apt update
sudo apt -y install cuda-toolkit-12-3
```

Next, install the NVIDIA driver:

```bash
sudo apt install -y cuda-drivers
```

Finally, make sure that `PATH` and `LD_LIBRARY_PATH` are updated to include the version installed. This is best done by adding them to the `.bashrc` or ensuring that they are set as part of a build script.

```bash
export PATH="/usr/local/cuda-12.3/bin:$PATH"
export LD_LIBRARY_PATH="/usr/local/cuda-12.3/lib64:$LD_LIBRARY_PATH"
```

After this it is just a matter of configuring the prefered editor. For Visual Studio Code, [Nsight Visual Studio Code Edition](https://developer.nvidia.com/nsight-visual-studio-code-edition) may be installed which ensure that built-in CUDA functions will be properly detected by the linter and tooltips.

## Building

The basic way of building is through the `nvcc` compiler. The basic demo code of `cuda_device.cu`, it can be built via:

```bash
mkdir bin
nvcc -o bin/cuda_device cuda_device.cu
```