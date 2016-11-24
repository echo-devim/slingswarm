# The name of our project is "HELLO". CMakeLists files in this project can
# refer to the root source directory of the project as ${HELLO_SOURCE_DIR} and
# to the root binary directory of the project as ${HELLO_BINARY_DIR}.
cmake_minimum_required (VERSION 2.6)
SET(CMAKE_COLOR_MAKEFILE ON)
SET(CMAKE_VERBOSE_MAKEFILE OFF)
project (slingswarm-launcher)
list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/vala )
# Recurse into the "Hello" and "Demo" subdirectories. This does not actually
# cause another cmake executable to run. The same process will walk through
# the project's entire directory structure.

#add_subdirectory (src)

find_package(PkgConfig)
pkg_check_modules(DEPS REQUIRED unique-3.0 gtk+-3.0 gee-0.8 gio-unix-2.0 libgnome-menu-3.0)
pkg_check_modules(GTHREAD REQUIRED "gthread-2.0 >= 2.14.0")

add_definitions(${DEPS_CFLAGS})

link_libraries(${DEPS_LIBRARIES} ${GTHREAD_LIBRARIES})

link_directories(${DEPS_LIBRARY_DIRS})

find_package(Vala REQUIRED)
include(ValaVersion)
ensure_vala_version("0.14.0" MINIMUM)

include(ValaPrecompile)
vala_precompile(VALA_C
    slingshot.vala
    frontend/widgets/AppItem.vala
    frontend/widgets/CompositedWindow.vala
    frontend/widgets/Indicators.vala
    frontend/widgets/Searchbar.vala
    frontend/Utilities.vala
    frontend/Color.vala
    backend/GMenuEntries.vala
PACKAGES
    gtk+-3.0
    gee-0.8
    gio-unix-2.0
    libgnome-menu-3.0
    unique-3.0
OPTIONS
    --thread
    )

INSTALL (FILES usr/slingswarm-launcher.desktop DESTINATION /usr/share/applications/)
INSTALL (FILES usr/slingswarm-launcher.png DESTINATION /usr/share/icons/)
add_definitions(${CFLAGS} -Wall -Winit-self -Wwrite-strings -Wunreachable-code
                          -Wstrict-prototypes -DGMENU_I_KNOW_THIS_IS_UNSTABLE -DWNCK_I_KNOW_THIS_IS_UNSTABLE )
add_executable(slingswarm-launcher ${VALA_C})
target_link_libraries(slingswarm-launcher m)

install(TARGETS slingswarm-launcher RUNTIME DESTINATION bin)
