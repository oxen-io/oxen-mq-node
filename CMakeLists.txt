cmake_minimum_required(VERSION 3.13)
project(oxenmq-node)



set(BUILD_SHARED_LIBS OFF CACHE BOOL "disable shared oxen-mq")

# include the pile of static deps to build when cross compiling
if(CMAKE_CROSSCOMPILING)
  include(${CMAKE_CURRENT_SOURCE_DIR}/cmake/static-deps.cmake)
endif()

add_subdirectory(oxen-mq)

add_library(${PROJECT_NAME} SHARED src/oxenmq.cpp ${CMAKE_JS_SRC})
target_include_directories(${PROJECT_NAME} PRIVATE ${CMAKE_JS_INC})

# we make this an interface library because on some platforms link order of all the binary objects DO matter
add_library(zmq_node_shim INTERFACE)
if(WIN32)
  # we need to add napi stub functions so we can link with mingw
  add_subdirectory(node-api-stub)
  # link order here DOES with mingw matter and i hate it
  target_link_libraries(zmq_node_shim INTERFACE node_api oxenmq::oxenmq ws2_32 iphlpapi)
else()
  target_link_libraries(zmq_node_shim INTERFACE oxenmq::oxenmq)
endif()

target_link_libraries(${PROJECT_NAME} PRIVATE zmq_node_shim ${CMAKE_JS_LIB})

set_target_properties(${PROJECT_NAME} PROPERTIES
  POSITION_INDEPENDENT_CODE ON
  CXX_STANDARD 17
  CXX_STANDARD_REQUIRED ON
  CXX_EXTENSIONS OFF
  PREFIX ""
  OUTPUT_NAME "oxenmq"
  SUFFIX ".node")

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
