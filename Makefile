BUILD_LITE = $(abspath ./build-lite)
PREFIX_LITE = $(abspath ./prefix-lite)

.PHONY: all clean clobber graphviz-lite


all: graphviz-lite viz-lite.js

clean:
	rm -f module-lite.js viz-lite.js

clobber: | clean
	rm -rf $(BUILD_LITE) $(PREFIX_LITE)


viz-lite.js: src/pre.js module-lite.js src/post.js
	cat $^ > $@

module-lite.js: src/viz.c
	emcc -D VIZ_LITE -v -Os --closure 1 --memory-init-file 0 -s USE_ZLIB=1 -s MODULARIZE=1 -s EXPORTED_FUNCTIONS="['_vizRenderFromString', '_aglasterr', '_dtextract', '_Dtqueue', '_dtopen', '_dtdisc', '_Dtobag', '_Dtoset', '_Dttree']" -s EXPORTED_RUNTIME_METHODS="['Pointer_stringify', 'ccall', 'UTF8ToString']" -o $@ $< -I$(PREFIX_LITE)/include -I$(PREFIX_LITE)/include/graphviz -L$(PREFIX_LITE)/lib -L$(PREFIX_LITE)/lib/graphviz -lgvplugin_core -lgvplugin_dot_layout -lcdt -lcgraph -lgvc -lgvpr -lpathplan -lxdot -lz


$(PREFIX_LITE):
	mkdir -p $(PREFIX_LITE)

graphviz-lite: | $(BUILD_LITE)/graphviz-2.38.0 $(PREFIX_LITE)
	cd $(BUILD_LITE)/graphviz-2.38.0 && ./configure
	cd $(BUILD_LITE)/graphviz-2.38.0/lib/gvpr && make mkdefs
	mkdir -p $(BUILD_LITE)/graphviz-2.38.0/FEATURE
	cp hacks/FEATURE/sfio hacks/FEATURE/vmalloc $(BUILD_LITE)/graphviz-2.38.0/FEATURE
	cd $(BUILD_LITE)/graphviz-2.38.0 && emconfigure ./configure --disable-ltdl --enable-static --disable-shared --prefix=$(PREFIX_LITE)
	cd $(BUILD_LITE)/graphviz-2.38.0 && emmake make CFLAGS="-fno-common -Wno-implicit-function-declaration"
	cd $(BUILD_LITE)/graphviz-2.38.0/lib && emmake make install
	cd $(BUILD_LITE)/graphviz-2.38.0/plugin && emmake make install


$(BUILD_LITE):
	mkdir -p $(BUILD_LITE)

$(BUILD_LITE)/graphviz-2.38.0: sources/graphviz-2.38.0.tar.gz | $(BUILD_LITE)
	tar -zxf sources/graphviz-2.38.0.tar.gz -C $(BUILD_LITE)


sources:
	mkdir -p sources

sources/graphviz-2.38.0.tar.gz: | sources
	curl -L "http://www.graphviz.org/pub/graphviz/stable/SOURCES/graphviz-2.38.0.tar.gz" -o sources/graphviz-2.38.0.tar.gz
