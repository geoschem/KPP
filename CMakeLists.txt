# KPP-for-GEOS-Chem high-level CMakeLists.txt

#-----------------------------------------------------------------------------
# Define project and version number
#-----------------------------------------------------------------------------
cmake_minimum_required (VERSION 3.13)
project (kpp-for-geos-chem
  VERSION 3.0.0
  LANGUAGES C
)

#-----------------------------------------------------------------------------
# Set CMake policies.  For more information, see:
#
# https://cmake.org/cmake/help/latest/policy/CMP0054.html
# https://cmake.org/cmake/help/latest/policy/CMP0057.html
# https://cmake.org/cmake/help/latest/policy/CMP0074.html
# https://cmake.org/cmake/help/latest/policy/CMP0079.html
#-----------------------------------------------------------------------------
cmake_policy(SET CMP0054 NEW)
cmake_policy(SET CMP0057 NEW)
if(POLICY CMP0074)
  cmake_policy(SET CMP0074 NEW)
endif()
if(POLICY CMP0079)
  cmake_policy(SET CMP0079 NEW)
endif()

#-----------------------------------------------------------------------------
# Add directories and functions to the search path
#-----------------------------------------------------------------------------

# Add CMakeScripts/ to the module path and import helper functions
list(INSERT CMAKE_MODULE_PATH 0 ${CMAKE_CURRENT_SOURCE_DIR}/CMakeScripts)
include(KPP-Helpers)

# Add the build directory to the search path
include_directories(${CMAKE_CURRENT_BINARY_DIR})

#-----------------------------------------------------------------------------
# Print header with the CMake project version and the KPP repo version
#-----------------------------------------------------------------------------
get_repo_version(KPP_REPO_VERSION ${CMAKE_CURRENT_SOURCE_DIR})
message("=================================================================")
message("KPP-for-GEOS-Chem ${PROJECT_VERSION}")
message("Current status: ${KPP_REPO_VERSION}")
message("=================================================================")

#-----------------------------------------------------------------------------
# Look for Bison and Flex on the system (dependencies of KPP)
#-----------------------------------------------------------------------------
find_package(BISON)
find_package(FLEX)

#-----------------------------------------------------------------------------
# Declare the KppBuildProperties
#
# All KPP targets depend on this. This is used to control the compiler
# options and definitions for KPP m targets (via inheritance).
#-----------------------------------------------------------------------------
add_library(KppBuildProperties INTERFACE)

set(KPP_DETECTED_C_COMPILER_ID ${CMAKE_C_COMPILER_ID}
    CACHE INTERNAL "Logging the COMPILER_ID to CMakeCache.txt"
)
set(KPP_DETECTED_C_COMPILER_VERSION ${CMAKE_C_COMPILER_VERSION}
    CACHE INTERNAL "Logging the compiler version to CMakeCache.txt"
)

set(KPP_C_FLAGS_Intel
  -g
  CACHE STRING "KPP compiler flags for all build types with Intel compilers"
)
set(KPP_C_FLAGS_RELEASE_Intel
   -g
    CACHE STRING "KPP compiler flags for build type release with Intel compilers"
)
set(KPP_C_FLAGS_RELWITHDEBINFO_Intel
    -g
    CACHE STRING "KPP compiler flags for build type relwithdebinfo with Intel compilers"
)
set(KPP_C_FLAGS_DEBUG_Intel
    -g -O0 -Wall
    CACHE STRING "KPP compiler flags for build type debug with Intel compilers"
)

set(KPP_C_FLAGS_GNU
    -g
    CACHE STRING "KPP compiler flags for all build types with GNU compilers"
)
set(KPP_C_FLAGS_RELEASE_GNU
  -g
  CACHE STRING "KPP compiler flags for build type release with GNU compilers"
)
set(KPP_C_FLAGS_RELWITHDEBINFO_GNU
   -g
   CACHE STRING "KPP compiler flags for build type relwithdebinfo with GNU compilers"
)
set(KPP_C_FLAGS_DEBUG_GNU
  -g -O0 -Wall
  CACHE STRING "KPP compiler flags for build type debug with GNU compilers"
)

set(KPP_SUPPORTED_COMPILER_IDS "Intel" "GNU")
if(NOT CMAKE_C_COMPILER_ID IN_LIST KPP_SUPPORTED_COMPILER_IDS)
   message(FATAL_ERROR "KPP does not support ${CMAKE_C_COMPILER_ID} compilers")
endif()

#---------------------------------------------------------------------
# Assign compiler options to build properties
#---------------------------------------------------------------------
target_compile_options(KppBuildProperties
   INTERFACE
   $<$<STREQUAL:${CMAKE_C_COMPILER_ID},Intel>:
      ${KPP_C_FLAGS_Intel}
      $<$<CONFIG:Debug>:${KPP_C_FLAGS_DEBUG_Intel}>
      $<$<CONFIG:RelWithDebInfo>:${KPP_C_FLAGS_RELWITHDEBINFO_Intel}>
      $<$<CONFIG:Release>:${KPP_C_FLAGS_RELEASE_Intel}>
   >
   $<$<STREQUAL:${CMAKE_C_COMPILER_ID},GNU>:
      ${KPP_Fortran_FLAGS_GNU}
      $<$<CONFIG:Debug>:${KPP_C_FLAGS_DEBUG_GNU}>
      $<$<CONFIG:RelWithDebInfo>:${KPP_C_FLAGS_RELWITHDEBINFO_GNU}>
      $<$<CONFIG:Release>:${KPP_C_FLAGS_RELEASE_GNU}>
   >
)

#-----------------------------------------------------------------------------
# Define where locally-built library files (*.lib) will be placed
#-----------------------------------------------------------------------------
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/lib)
target_include_directories(KppBuildProperties
  INTERFACE ${CMAKE_ARCHIVE_OUTPUT_DIRECTORY}
)

#-----------------------------------------------------------------------------
# Set CMAKE_BUILD_TYPE to Release by default
#-----------------------------------------------------------------------------
if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE "Release"
    CACHE STRING "Set the build type"
    FORCE
  )
endif()

#-----------------------------------------------------------------------------
# Look in other folders for source code
#-----------------------------------------------------------------------------
add_subdirectory(kpp-code)

#-----------------------------------------------------------------------------
# Display variables
#-----------------------------------------------------------------------------
pretty_print(SECTION "Useful CMake variables")
pretty_print(VARIABLE PROJECT_SOURCE_DIR)
pretty_print(VARIABLE CMAKE_BINARY_DIR)
pretty_print(VARIABLE CMAKE_BUILD_TYPE)

#-----------------------------------------------------------------------------
# Write KppBuildProperties's configuration to a file
#-----------------------------------------------------------------------------
get_target_property(BT_DEFINITIONS  KppBuildProperties
    INTERFACE_COMPILE_DEFINITIONS
)
get_target_property(BT_OPTIONS      KppBuildProperties
    INTERFACE_COMPILE_OPTIONS
)
get_target_property(BT_LIBRARIES    KppBuildProperties
    INTERFACE_LINK_LIBRARIES
)
get_target_property(BT_INCLUDES     KppBuildProperties
    INTERFACE_INCLUDE_DIRECTORIES
)
file(WRITE ${CMAKE_BINARY_DIR}/KppBuildProperties.txt
    "# This file shows the KppBuildProperties's configuration.\n"
    "\n"
    "KppBuildProperties::INTERFACE_COMPILE_DEFINITIONS:${BT_DEFINITIONS}\n"
    "KppBuildProperties::INTERFACE_COMPILE_OPTIONS:${BT_OPTIONS}\n"
    "KppBuildProperties::INTERFACE_LINK_LIBRARIES:${BT_LIBRARIES}\n"
    "KppBuildProperties::INTERFACE_INCLUDE_DIRECTORIES:${BT_INCLUDES}\n"
)
