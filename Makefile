.PHONY: pkg

pkgname = ZTPi-$(shell cat version)
build_dir = _build_tmp

pkg: 
	echo "Creating build directories"
	mkdir -p $(build_dir)/$(pkgname)
	cp -R pkg/deb/* $(build_dir)/$(pkgname) 
	dpkg-deb --build $(build_dir)/$(pkgname)

clean:
	rm -fr $(build_dir)
