


# GUI
cmake-gui

# TUI
ccmake

# Configure
mkdir build/
cd build
cmake -LA -DVAR=True ..

# Build using cmake:
cmake --build /path/to/build/dir -j4

# Install


# Clean cmake output
cmake --build C:/foo/build/ --target clean

# See what libraries the linker knows about
/sbin/ldconfig -p | grep <name_of_your_lib>
