set -e

if [ -f "$PWD/build/bin/aseprite" ]; then
  echo "Skipping build as cache hit."
  exit 0
fi

cd clone
git checkout temp

git submodule update --init --recursive --depth 1 submodules/aseprite/aseprite
cd ..

if [ "$(uname)" == "Darwin" ]; then
  brew install ninja
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  # Check if we're running as root (common in Docker containers)
  if [ "$(id -u)" -eq 0 ]; then
    # Running as root, no sudo needed
    apt-get update
    apt-get install -y g++ clang cmake ninja-build libx11-dev libxcursor-dev libxi-dev libxrandr-dev libgl1-mesa-dev libfontconfig1-dev
  else
    # Not running as root, use sudo
    sudo apt-get update
    sudo apt-get install -y g++ clang cmake ninja-build libx11-dev libxcursor-dev libxi-dev libxrandr-dev libgl1-mesa-dev libfontconfig1-dev
  fi
else
  choco install ninja
fi

cmake -E make_directory build
cmake -E chdir build cmake -G Ninja -DENABLE_UI=OFF ../clone/submodules/aseprite/aseprite
cd build

if [ "$(uname)" == "Darwin" ]; then
  ninja
elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
  ninja
else
  ninja -j 1
fi
