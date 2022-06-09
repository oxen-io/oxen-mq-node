cmake_minimum_required(VERSION 3.13)

project(oxenmq-node)

set(BUILD_SHARED_LIBS OFF CACHE BOOL "disable shared oxen-mq")
add_subdirectory(oxen-mq)

add_library(${PROJECT_NAME} SHARED src/oxenmq.cpp ${CMAKE_JS_SRC})
target_include_directories(${PROJECT_NAME} PRIVATE ${CMAKE_JS_INC})
target_link_libraries(${PROJECT_NAME} PRIVATE oxenmq::oxenmq ${CMAKE_JS_LIB})
set_target_properties(${PROJECT_NAME} PROPERTIES PREFIX "" OUTPUT_NAME "oxenmq" SUFFIX ".node")

target_compile_definitions(${PROJECT_NAME} PRIVATE
    NAPI_VERSION=6
    NAPI_CPP_EXCEPTIONS
    )

# Include node-addon-api wrappers
execute_process(COMMAND node -p "require('node-addon-api').include"
        WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
        OUTPUT_VARIABLE NODE_ADDON_API_DIR
        )
string(REPLACE "\n" "" NODE_ADDON_API_DIR ${NODE_ADDON_API_DIR})
string(REPLACE "\"" "" NODE_ADDON_API_DIR ${NODE_ADDON_API_DIR})
target_include_directories(${PROJECT_NAME} PRIVATE ${NODE_ADDON_API_DIR})
