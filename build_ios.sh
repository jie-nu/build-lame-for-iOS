ld
rm -rf build/* #*/

MIN_VERSION="6.0"

function build_lame()
{
    make distclean

    ./configure \
        CFLAGS="-isysroot /Applications/Xcode.app/Contents/Developer/Platforms/${SDK}.platform/Developer/SDKs/$SDK$SDK_VERSION.sdk" \
        CC="/Applications/Xcode.app/Contents/Developer/usr/bin/gcc -arch $PLATFORM -miphoneos-version-min=7.0" \
        --prefix="/Users/$USER/Desktop/$PROJECTNAME" \
        --host="$HOST" \
        --disable-shared \
        --enable-static \
        --disable-frontend \

    make
    cp "$PROJECTNAME/.libs/$PROJECTNAME.a" "build/$PROJECTNAME-$PLATFORM.a"
}

function build_lame2()
{
    make distclean

    # SDK must lower case
    SDK_ROOT=$(xcrun --sdk $(echo ${SDK} | tr '[:upper:]' '[:lower:]') --show-sdk-path)

    ./configure \
        CFLAGS="-arch ${PLATFORM} -pipe -std=c99 -isysroot ${SDK_ROOT} -miphoneos-version-min=${MIN_VERSION}" \
        --host="$HOST" \
        --enable-static \
        --disable-decoder \
        --disable-frontend \
        --disable-debug \
        --disable-dependency-tracking

    make
    cp "$PROJECTNAME/.libs/$PROJECTNAME.a" "build/$PROJECTNAME-$PLATFORM.a"
}


PROJECTNAME=libmp3lame
SDK_VERSION=9.1

SDK="iPhoneSimulator"
HOST="i686-apple-darwin12.5.0"
PLATFORM="i686"
build_lame

PLATFORM="x86_64"
build_lame

SDK="iPhoneOS"
HOST="arm-apple-darwin9"
PLATFORM="armv7"
build_lame2

PLATFORM="armv7s"
build_lame2

PLATFORM="arm64"
build_lame2


lipo -create build/$PROJECTNAME-* -output build/$PROJECTNAME.a
