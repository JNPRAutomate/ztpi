pkg:
	echo "Creating build directories"
	export PKG_NAME=ZTPi-`cat `
	export BUILD_DIR=_build_tmp
	mkdir $BUILD_DIR/$PKG_NAME
	cp -R pkg/* $BUILD_DIR/$PKG_NAME
	cd _build_tmp/
	dpkg-deb --build $PKG_NAME
