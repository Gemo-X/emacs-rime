
cmake_minimum_required(VERSION 3.6)

project(
  emacs-rime
  LANGUAGES C
  )

include_directories(
  include
)

aux_source_directory(
  src DIR_SRCS
)

add_library(rime-emacs SHARED ${DIR_SRCS})

# enable_testing()
#
# add_test(NAME emacs-rime COMMAND
#   emacs --batch
#     -L "${CMAKE_CURRENT_BINARY_DIR}"
#     -L "${CMAKE_CURRENT_SOURCE_DIR}/test"
#     -l rime
#     -f ert-run-tests-batch-and-exit
#   )
