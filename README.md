librsvg-d
=========

librsvg is a library to render SVG files using cairo. librsvg-d is a D binding for librsvg.

Limitations
-----------

Not all of librsvg is bound. You may need to add functionality to suit your needs. Pull requests
are very welcome.

Dependencies
------------

librsvg depends on cairo and libxml. librsvg-d also depends on cairod. Projects that use librsvg-d
need to link against librsvg. The easiest way to use librsvg-d is via dub:
```
"dependencies": {
    "librsvg-d": ">=0.0.3"
},
"libs": ["rsvg-2.0"]
```

Troubleshooting
---------------

On Mac OS X, if you get an error `ld: library not found for -lrsvg-2.0`, then run
```
export PKG_CONFIG_PATH=/opt/X11/lib/pkgconfig:$PKG_CONFIG_PATH
```

If you need PDF, PS, or SVG surface support, you may need to modify cairod's `src/cairo/c/config.d`.
