set(CMAKE_SYSTEM_NAME Windows)
set(TOOLCHAIN_PREFIX x86_64-w64-mingw32)
set(WIN64_CROSS_COMPILE ON)
set(CROSS_TARGET x86_64-w64-mingw32)

set(TOOLCHAIN_PATHS
 /usr/${TOOLCHAIN_PREFIX}
 /usr/local/opt/mingw-w64/toolchain-x86_64
 /usr/local/opt/mingw-w64/toolchain-x86_64/x86_64-w64-mingw32
 /opt/mingw64
 /home/$ENV{USER}/mingw32
 /home/$ENV{USER}/mingw64
 /home/$ENV{USER}/mingw64/${TOOLCHAIN_PREFIX}
 /home/$ENV{USER}/mingw32/${TOOLCHAIN_PREFIX})

set(CMAKE_SYSTEM_VERSION 6.0)

# the minimum windows version, set to 6 rn because supporting older windows is hell
set(_winver 0x0600)
add_definitions(-D_WIN32_WINNT=${_winver})

# target environment on the build host system
# second one is for non-root installs
set(CMAKE_FIND_ROOT_PATH ${TOOLCHAIN_PATHS})

add_definitions("-DWINNT_CROSS_COMPILE")

# modify default behavior of FIND_XXX() commands
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE NEVER)

# cross compilers to use
if($ENV{COMPILER} MATCHES "clang")
    set(USING_CLANG ON)
    set(CMAKE_C_COMPILER ${TOOLCHAIN_PREFIX}-clang)
    set(CMAKE_CXX_COMPILER ${TOOLCHAIN_PREFIX}-clang++)
else()
    set(CMAKE_C_COMPILER ${TOOLCHAIN_PREFIX}-gcc${TOOLCHAIN_SUFFIX})
    set(CMAKE_CXX_COMPILER ${TOOLCHAIN_PREFIX}-g++${TOOLCHAIN_SUFFIX})
endif()

set(CMAKE_RC_COMPILER ${TOOLCHAIN_PREFIX}-windres)
set(ARCH_TRIPLET ${CROSS_TARGET})
set(WIN32 ON)
set(CMAKE_SHARED_LINKER_FLAGS -fstack-protector)
