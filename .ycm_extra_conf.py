def Settings(**kwargs):
    kwargs['filename']
    return {
        "flags": ["-x", "c++", "-std=c++17", "-Wall", "-Wextra", "-Werror", "-I/usr/include/node", "-Inode_modules/node-addon-api"],
    }
