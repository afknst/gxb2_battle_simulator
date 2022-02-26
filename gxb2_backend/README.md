# gxb2_backend

The original **COMPILED** code is required:
```
ln -s <COMPILED_SRC>/app <HERE>/app
ln -s <COMPILED_SRC>/base <HERE>/base
ln -s <COMPILED_SRC>/data <HERE>/data
ln -s <COMPILED_SRC>/lib <HERE>/lib
```

Dependencies: luajit and turbo.

To start a server (with `2333` being the port):
```
luajit -e 'require("server")(2333)'
```