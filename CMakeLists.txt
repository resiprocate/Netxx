cmake_minimum_required(VERSION 3.5 FATAL_ERROR)
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/build/cmake_modules")

if(POLICY CMP0042)
  CMAKE_POLICY(SET CMP0042 NEW)
endif(POLICY CMP0042)
if(POLICY CMP0077)
   CMAKE_POLICY(SET CMP0077 NEW)
endif(POLICY CMP0077)

project(Netxx VERSION 0.3.2)

include(CheckSymbolExists)
include(GNUInstallDirs)
include(Utilities)

enable_testing()

# https://cmake.org/cmake/help/latest/module/FindThreads.html
set(CMAKE_THREAD_PREFER_PTHREAD TRUE)
find_package(Threads)
if(Threads_FOUND)
   add_definitions(-DUSE_POSIX_LOCKING)
else()
   if(WIN32)
      add_definitions(-DUSE_WINDOWS_LOCKING)
   else()
      exit()
   endif()
endif()
if(CMAKE_USE_PTHREADS_INIT)
   add_compile_definitions(_REENTRANT)
   add_compile_options(-pthread)
endif()

option(ENABLE_TLS "Use OpenSSL" FALSE)
option(BUILD_EXAMPLES "Build the examples" FALSE)

if(WIN32)
   set(BUILD_SHARED_LIBS_DEFAULT OFF)
else()
   set(BUILD_SHARED_LIBS_DEFAULT ON)
endif()
option(BUILD_SHARED_LIBS "Build libraries as shared" ${BUILD_SHARED_LIBS_DEFAULT})

if(ENABLE_TLS)
   find_package(OpenSSL REQUIRED)
   if(OPENSSL_FOUND)
      include_directories(${OPENSSL_INCLUDE_DIR})
   endif()
endif()

add_subdirectory(src)
add_subdirectory(examples)


