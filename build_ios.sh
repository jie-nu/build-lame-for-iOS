ld
rm -rf build/* #*/

function build_lame()
{
    make distclean

    SDK_ROOT=$(xcrun --sdk $(echo ${SDK} | tr '[:upper:]' '[:lower:]') --show-sdk-path)

    ./configure \
        CFLAGS="-isysroot ${SDK_ROOT}" \
        CC="/Applications/Xcode.app/Contents/Developer/usr/bin/gcc -arch $PLATFORM -miphoneos-version-min=${MIN_VERSION}" \
        --prefix="/Users/$USER/Desktop/$PROJECTNAME" \
        --host="$HOST" \
        --disable-shared \
        --enable-static \
        --disable-frontend \
        --disable-debug \
        --disable-dependency-tracking

    make
    cp "$PROJECTNAME/.libs/$PROJECTNAME.a" "build/$PROJECTNAME-$PLATFORM.a"
}

function build_lame2()
{
    make distclean

    SDK_ROOT=$(xcrun --sdk $(echo ${SDK} | tr '[:upper:]' '[:lower:]') --show-sdk-path)

    ./configure \
        CFLAGS="-arch ${PLATFORM} -pipe -std=c99 -isysroot ${SDK_ROOT} -miphoneos-version-min=${MIN_VERSION}" \
        --host="$HOST" \
        --disable-shared \
        --enable-static \
        --disable-frontend \
        --disable-debug \
        --disable-dependency-tracking

    make
    cp "$PROJECTNAME/.libs/$PROJECTNAME.a" "build/$PROJECTNAME-$PLATFORM.a"
}


PROJECTNAME=libmp3lame

MIN_VERSION="7.0"
SDK="iPhoneSimulator"
HOST="i686-apple-darwin12.5.0"
PLATFORM="i686"
build_lame

PLATFORM="x86_64"
build_lame

MIN_VERSION="6.0"
SDK="iPhoneOS"
HOST="arm-apple-darwin9"
PLATFORM="armv7"
build_lame2

PLATFORM="armv7s"
build_lame2

PLATFORM="arm64"
build_lame2


lipo -create build/$PROJECTNAME-* -output build/$PROJECTNAME.a
