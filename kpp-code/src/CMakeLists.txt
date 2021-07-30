# kpp-code/src/CMakeLists.txt
# Compiles KPP source code

# Find bison and flex
find_package(BISON REQUIRED)
message(STATUS "Bison executable: ${BISON_EXECUTABLE}")

find_package(FLEX REQUIRED)       # flex is required
message(STATUS "Flex executable:  ${FLEX_EXECUTABLE}")
message(STATUS "Flex libraries:   ${FLEX_LIBRARIES}")
# FindFLEX.cmake doesn't fail if libfl isn't found. We need it so
# we need to assert it's found.
if(NOT FLEX_LIBRARIES)
  message(FATAL_ERROR "Failed to find libfl (libfl.so or libfl.a)!")
endif()

#-----------------------------------------------------------------------------
# Copy the CMake project version number to the version.h file
#-----------------------------------------------------------------------------
message(VERBOSE "Creating ${CMAKE_CURRENT_SOURCE_DIR}/version.h")
configure_file(version.h.in version.h @ONLY)

#-----------------------------------------------------------------------------
# Use Bison to create Parser files: y.tab.c and y.tab.h
# Copy y.tab.h back to the source code folder as this is what works
#-----------------------------------------------------------------------------
BISON_TARGET(Parser scan.y y.tab.c
  COMPILE_FLAGS -d
  DEFINES_FILE ${CMAKE_CURRENT_BINARY_DIR}/y.tab.h
)
message(VERBOSE "Bison outputs: ${BISON_Parser_OUTPUTS}")

#-----------------------------------------------------------------------------
# Use Flex to creat Lexer files: lex.yy.c
# Make the Lexer depend on the Parser so that it can use Parser tokens#
#-----------------------------------------------------------------------------
FLEX_TARGET(Lexer scan.l lex.yy.c)
ADD_FLEX_BISON_DEPENDENCY(Lexer Parser)
message(VERBOSE "Flex outputs: ${FLEX_Lexer_OUTPUTS}")

#-----------------------------------------------------------------------------
# Compile KPP source code into libKppSource.a
#-----------------------------------------------------------------------------
add_library(KppSource
  STATIC EXCLUDE_FROM_ALL
  code.c
  code_c.c
  code_f77.c
  code_f90.c
  code_matlab.c
  debug.c
  gen.c
  scanner.c
  scanutil.c
  ${BISON_Parser_OUTPUTS}
  ${FLEX_Lexer_OUTPUTS}
)
target_include_directories(KppSource
  PUBLIC ${CMAKE_CURRENT_BINARY_DIR} ${CMAKE_CURRENT_SOURCE_DIR})
target_link_libraries(KppSource PUBLIC ${FLEX_LIBRARIES})


#-----------------------------------------------------------------------------
# Declare the kpp target
#-----------------------------------------------------------------------------
add_executable(kpp kpp.c)
target_link_libraries(kpp PUBLIC KppSource)
set_target_properties(kpp
  PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin
)
install(TARGETS kpp RUNTIME)
