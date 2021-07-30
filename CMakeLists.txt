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
# Define project and version number
#-----------------------------------------------------------------------------
if(CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
  set(CMAKE_INSTALL_PREFIX "${PROJECT_SOURCE_DIR}" CACHE PATH "..." FORCE)
endif()

#-----------------------------------------------------------------------------
# Set CMake policies.  For more information, see:
#
# https://cmake.org/cmake/help/latest/policy/CMP0054.html
# https://cmake.org/cmake/help/latest/policy/CMP0057.html
# https://cmake.org/cmake/help/latest/policy/CMP0074.html
# https://cmake.org/cmake/help/latest/policy/CMP0079.html
# https://cmake.org/cmake/help/latest/policy/CMP0088.html
# https://cmake.org/cmake/help/latest/policy/CMP0098.html
#-----------------------------------------------------------------------------
cmake_policy(SET CMP0054 NEW)
cmake_policy(SET CMP0057 NEW)
if(POLICY CMP0074)
  cmake_policy(SET CMP0074 NEW)
endif()
if(POLICY CMP0079)
  cmake_policy(SET CMP0079 NEW)
endif()
if (POLICY CMP0088)
  cmake_policy(SET CMP0088 NEW)
endif()
if (POLICY CMP0098)
  cmake_policy(SET CMP0098 NEW)
endif()

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
  -g -w
  CACHE STRING "KPP compiler flags for all build types with GNU compilers"
)
set(KPP_C_FLAGS_RELEASE_GNU
  -g -w
  CACHE STRING "KPP compiler flags for build type release with GNU compilers"
)
set(KPP_C_FLAGS_RELWITHDEBINFO_GNU
  -g -w
   CACHE STRING "KPP compiler flags for build type relwithdebinfo with GNU compilers"
)
set(KPP_C_FLAGS_DEBUG_GNU
  -O0 -Wall
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
      ${KPP_C_FLAGS_GNU}
      $<$<CONFIG:Debug>:${KPP_C_FLAGS_DEBUG_GNU}>
      $<$<CONFIG:RelWithDebInfo>:${KPP_C_FLAGS_RELWITHDEBINFO_GNU}>
      $<$<CONFIG:Release>:${KPP_C_FLAGS_RELEASE_GNU}>
   >
)

#-----------------------------------------------------------------------------
# Define library and include paths
#-----------------------------------------------------------------------------

# Define where locally-built library files (*.lib) will be placed
set_target_properties(KppBuildProperties
  PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/bin
  ARCHIVE_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR}/lib
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
