using BinaryBuilder

# Collection of sources required to build Pixman
sources = [
    "https://www.cairographics.org/releases/pixman-0.34.0.tar.gz" =>
    "21b6b249b51c6800dc9553b65106e1e37d0e25df942c90531d4c3997aa20a88e",
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
cd pixman-0.34.0/
./configure --prefix=$prefix --host=$target
make -j${nproc}
make install
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    BinaryProvider.Linux(:i686, :glibc),
    BinaryProvider.Linux(:x86_64, :glibc),
    BinaryProvider.Linux(:aarch64, :glibc),
    BinaryProvider.Linux(:armv7l, :glibc),
    BinaryProvider.Linux(:powerpc64le, :glibc),
    BinaryProvider.MacOS(),
    # Doesn't work on windows yet, sadly
    #BinaryProvider.Windows(:i686),
    #BinaryProvider.Windows(:x86_64)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libpixman", :libpixman)
]

# Dependencies that must be installed before this package can be built
dependencies = [
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, "Pixman", sources, script, platforms, products, dependencies)
