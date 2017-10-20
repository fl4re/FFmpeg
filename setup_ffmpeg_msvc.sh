HomeDir="$(dirname $(readlink -f $0))"
ItIsATrap() {
	errcode=$?
    echo "FFmpeg build error! Exit code: $errcode " > $HomeDir/setup_ffmpeg_msvc.log
    echo ", the command executing at the time of the error was " >> $HomeDir/setup_ffmpeg_msvc.log
    echo "$BASH_COMMAND" >> $HomeDir/setup_ffmpeg_msvc.log
    exit $errcode
}
rm -rf $HomeDir/setup_ffmpeg_msvc.log

cd "$VCINSTALLDIR"/BIN/amd64/
ToolChainDir="$(pwd)"
cd $HomeDir

trap ItIsATrap ERR TERM INT

# There is no need to clean before build
# Jenkins always delete everything before build
# Local build should not have to delete for efficiency


#echo -n "Cleaning FFmpeg binaries..."
#rm -rf ./win64
#mkdir ./win64
#echo "Done!"
#echo -n "Cleaning FFmpeg..."

#trap - ERR TERM INT
#make -i clean > /dev/null
#trap ItIsATrap ERR TERM INT
#echo "Done!"

echo -n "Configuring FFmpeg..."
PATH=$ToolChainDir:$PATH ./configure --arch=x86_64 --toolchain=msvc --disable-gpl --disable-network --disable-doc --disable-encoders --enable-avresample --enable-shared --prefix=./win64 $FL4RE_FFMPEG_CONFIGURE_FLAGS
echo "Done!"
echo -n "Making FFmpeg..."
PATH=$ToolChainDir:$PATH make -j8 $FL4RE_FFMPEG_MAKE_FLAGS
echo "Done!"
echo -n "Installing FFmpeg..."
PATH=$ToolChainDir:$PATH make install $FL4RE_FFMPEG_MAKE_INSTALL_FLAGS
echo "Done!"
echo -n "Patching FFmpeg libs..."
cd ./win64
for fname in lib/*.def; do FNAME_NP=${fname#*/}; FNAME_NN=${FNAME_NP%%-*}; PATH=$ToolChainDir:$PATH ${FL4RE_FFMPEG_WIN_LIB_TOOL:=lib} /MACHINE:x64 /DEF:$fname /OUT:bin/$FNAME_NN.lib; done
echo "Done!"
