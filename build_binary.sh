set -e

export MACOSX_DEPLOYMENT_TARGET="10.12"
BIN_DIR="./macos"
ITS_APPLE=1
echo "Configuring FFmpeg..."
./configure --cc=clang --cxx=clang++ --enable-shared --disable-gpl --disable-programs --disable-doc --enable-avresample --prefix=$BIN_DIR $FL4RE_FFMPEG_CONFIGURE_FLAGS
echo "Done!"
echo "Making FFmpeg..."
make -r -j8 $FL4RE_FFMPEG_MAKE_FLAGS
echo "Done!"
echo "Installing FFmpeg..."
make install $FL4RE_FFMPEG_MAKE_INSTALL_FLAGS
echo "Done!"
echo "Patching FFmpeg dylib files..."
if [ $ITS_APPLE ] ; then
    # patch the mutual references of libraries, so they would be
    # looking for each other within the directory of executable
    for libPath in ./macos/lib/*.dylib; do
        for everyLib in ./macos/lib/*.dylib; do
            libName=$(basename $everyLib)
            install_name_tool -change $everyLib @executable_path/$libName $libPath
        done
    done
fi
echo "Done!"
