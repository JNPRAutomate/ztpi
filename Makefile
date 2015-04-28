.PHONY: pkg

pkgname = ZTPi-$(shell cat version)
build_dir = _build_tmp

build: pkg clean

pkg:
	echo "Creating build directories"
	mkdir -p $(build_dir)/$(pkgname)
	cp -R pkg/deb/* $(build_dir)/$(pkgname)
	dpkg-deb --build $(build_dir)/$(pkgname)
	mkdir ship/
	mv $(build_dir)/$(pkgname).deb ship/

clean:
	rm -fr $(build_dir)
