#!/bin/bash

# 1. Detect Architecture
ARCH=$(uname -m)
if [ "$ARCH" == "x86_64" ]; then
    MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
elif [ "$ARCH" == "aarch64" ]; then
    MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh"
else
    echo "Error: Unsupported architecture $ARCH"
    exit 1
fi

INSTALLER="miniconda_installer.sh"
INSTALL_DIR="$HOME/miniconda3"

# 2. Download the installer using wget
echo "Downloading Miniconda for $ARCH..."
wget "$MINICONDA_URL" -O "$INSTALLER"

# 3. Install Miniconda
# -b: Batch mode (no manual prompts)
# -u: Update existing installation if present
# -p: Specify the installation prefix path
echo "Installing to $INSTALL_DIR..."
bash "$INSTALLER" -b -u -p "$INSTALL_DIR"

# 4. Cleanup: Delete the installer file
echo "Cleaning up installer file..."
rm "$INSTALLER"

# 5. Initialize Conda for Bash
echo "Initializing Conda..."
"$INSTALL_DIR/bin/conda" init bash

echo "--------------------------------------------------------"
echo "Installation complete."
echo "Please restart your terminal or run: source ~/.bashrc"
echo "--------------------------------------------------------"
