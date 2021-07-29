#!/bin/bash

# Script to remove all output from the build and bin directories

rm -rf bin/kpp*
rm -rf build/html
rm -rf build/bin/
rm -rf build/CMakeCache.txt
rm -rf build/CMakeFiles/
rm -rf build/cmake_install.cmake
rm -rf build/install_manifest.txt
rm -rf build/KppBuildProperties.txt
rm -rf build/kpp-code/
rm -rf build/lib/
rm -rf build/Makefile

