

# Show shared libraries used by an executable

ldd [option]... file...

ldd /usr/bin/vim

# See what libraries the linker knows about
/sbin/ldconfig -p | grep <name_of_your_lib>
