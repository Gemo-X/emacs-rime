cmake_minimum_required(VERSION 3.6)
project(
  emacs-rime
  LANGUAGES C
  )

if(NOT DEFINED env{EMACS_MAJOR_VERSION})
  set(EMACS_MAJOR_VERSION 26)
endif()

include_directories(
  include/emacs-module/${EMACS_MAJOR_VERSION}
  )

aux_source_directory(
  src DIR_SRCS
  )

add_library(rime-emacs SHARED ${DIR_SRCS})

if(APPLE)
  set_target_properties(rime-emacs PROPERTIES SUFFIX .so)
endif(APPLE)

if(WIN32)
  set_target_properties(rime-emacs PROPERTIES PREFIX lib)
endif(WIN32)

target_link_libraries(rime-emacs)
target_include_directories(rime-emacs SYSTEM PRIVATE)

if(CMAKE_COMPILER_IS_GNUCC)
  target_compile_options(rime-emacs PRIVATE -Wall -Wextra)
endif(CMAKE_COMPILER_IS_GNUCC)

add_custom_command(TARGET rime-emacs POST_BUILD COMMAND
  ${CMAKE_COMMAND} -E copy $<TARGET_FILE:rime-emacs> "${CMAKE_CURRENT_BINARY_DIR}/..")
