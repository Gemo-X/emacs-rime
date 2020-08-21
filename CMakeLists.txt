cmake_minimum_required(VERSION 3.6)
project(
  emacs-rime
  LANGUAGES C
  )

set(CMAKE_POSITION_INDEPENDENT_CODE TRUE CACHE BOOL "pic" FORCE)
set(BUILD_SHARED_LIBS OFF CACHE BOOL "shared" FORCE)
set(BUILD_CLAR OFF CACHE BOOL "clar" FORCE)
set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} -DEGIT_DEBUG")

include(${CMAKE_ROOT}/Modules/FindPkgConfig.cmake)
find_package(Rime REQUIRED)
if(Rime_FOUND)
  message("found rime")
endif(Rime_FOUND)

if(NOT DEFINED env{EMACS_MAJOR_VERSION})
  set(EMACS_MAJOR_VERSION 26)
endif()
message("EMACS_MAJOR_VERSION is ${EMACS_MAJOR_VERSION}")

message("${Rime_LIBRARIES} ${Rime_INCLUDE_DIR}")

include_directories(
  include/emacs-module/${EMACS_MAJOR_VERSION}
  )

aux_source_directory(
  src DIR_SRCS
  )

add_library(rime-emacs SHARED ${DIR_SRCS})
target_link_libraries(rime-emacs ${Rime_LIBRARIES})
target_include_directories(rime-emacs SYSTEM PRIVATE ${Rime_INCLUDE_DIR})

if(APPLE)
  set_target_properties(rime-emacs PROPERTIES SUFFIX .so)
endif(APPLE)

if(WIN32)
  set_target_properties(rime-emacs PROPERTIES PREFIX lib)
endif(WIN32)

if(CMAKE_COMPILER_IS_GNUCC)
  target_compile_options(rime-emacs PRIVATE -Wall -Wextra)
endif(CMAKE_COMPILER_IS_GNUCC)

add_custom_command(TARGET rime-emacs POST_BUILD COMMAND
  ${CMAKE_COMMAND} -E copy $<TARGET_FILE:rime-emacs> "${CMAKE_CURRENT_BINARY_DIR}/..")
