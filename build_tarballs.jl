using BinaryBuilder

# Collection of sources required to build Pixman
name = "Pixman"
version = v"0.34.0"
sources = [
    "https://www.cairographics.org/releases/pixman-0.34.0.tar.gz" =>
    "21b6b249b51c6800dc9553b65106e1e37d0e25df942c90531d4c3997aa20a88e",
    "patches",
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd pixman-0.34.0/

# Apply patch for compilation with clang
patch < $WORKSPACE/srcdir/patches/clang.patch

# Apply patch for arm on musl
patch -p1 < $WORKSPACE/srcdir/patches/arm_musl.patch

aclocal
automake

./configure --prefix=$prefix --host=$target
make -j${nproc}
make install
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = supported_platforms()

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libpixman", :libpixman)
]

# Dependencies that must be installed before this package can be built
dependencies = [
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)
