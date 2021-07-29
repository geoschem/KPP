# kpp-code/src/CMakeLists.txt
# Compiles KPP source code

#-----------------------------------------------------------------------------
# Copy the CMake project version number to the version.h file
#-----------------------------------------------------------------------------
message("Creating ${CMAKE_CURRENT_SOURCE_DIR}/version.h")
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/version.h.in
  ${CMAKE_CURRENT_SOURCE_DIR}/version.h @ONLY
)

#-----------------------------------------------------------------------------
# Copy source code to the build directory.  This is in order to get the
# '#include y.tab.h' in scanner.c to work properly, since that will look
# for the include file in the current folder.  If we place y.tab.h in the
# source code, we will break the separation between the build-generated
# files, which would be undesirable.
#-----------------------------------------------------------------------------
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/scan.h
  ${CMAKE_CURRENT_BINARY_DIR}/scan.h
)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/gdef.h
  ${CMAKE_CURRENT_BINARY_DIR}/gdef.h
)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/gdata.h
  ${CMAKE_CURRENT_BINARY_DIR}/gdata.h
)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/code.h
  ${CMAKE_CURRENT_BINARY_DIR}/code.h
)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/version.h
  ${CMAKE_CURRENT_BINARY_DIR}/version.h
)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/code.c
  ${CMAKE_CURRENT_BINARY_DIR}/code.c
)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/code_c.c
  ${CMAKE_CURRENT_BINARY_DIR}/code_c.c
)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/code_f77.c
  ${CMAKE_CURRENT_BINARY_DIR}/code_f77.c
)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/code_f90.c
  ${CMAKE_CURRENT_BINARY_DIR}/code_f90.c
)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/code_matlab.c
  ${CMAKE_CURRENT_BINARY_DIR}/code_matlab.c
)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/debug.c
  ${CMAKE_CURRENT_BINARY_DIR}/debug.c
)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/gen.c
  ${CMAKE_CURRENT_BINARY_DIR}/gen.c
)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/scanner.c
  ${CMAKE_CURRENT_BINARY_DIR}/scanner.c
)
configure_file(${CMAKE_CURRENT_SOURCE_DIR}/scanutil.c
  ${CMAKE_CURRENT_BINARY_DIR}/scanutil.c
)

#-----------------------------------------------------------------------------
# Use Bison to create Parser files: y.tab.c and y.tab.h
# Copy y.tab.h back to the source code folder as this is what works
#-----------------------------------------------------------------------------
find_package(BISON)
BISON_TARGET(Parser
  ${CMAKE_CURRENT_SOURCE_DIR}/scan.y ${CMAKE_CURRENT_BINARY_DIR}/y.tab.c
  COMPILE_FLAGS -d
  DEFINES_FILE ${CMAKE_CURRENT_BINARY_DIR}/y.tab.h
)

#-----------------------------------------------------------------------------
# Use Flex to creat Lexer files: lex.yy.c
# Make the Lexer depend on the Parser so that it can use Parser tokens#
#-----------------------------------------------------------------------------
find_package(FLEX)
FLEX_TARGET(Lexer
  ${CMAKE_CURRENT_SOURCE_DIR}/scan.l ${CMAKE_CURRENT_BINARY_DIR}/lex.yy.c
)
ADD_FLEX_BISON_DEPENDENCY(Lexer Parser)

#-----------------------------------------------------------------------------
# Print Bison/Flex variables to screen
#-----------------------------------------------------------------------------
pretty_print(SECTION "Bison")
pretty_print(VARIABLE BISON_EXECUTABLE)
pretty_print(VARIABLE BISON_COMPILE_FLAGS)
pretty_print(VARIABLE BISON_Parser_OUTPUTS)
pretty_print(SECTION "Flex")
pretty_print(VARIABLE FLEX_EXECUTABLE)
pretty_print(VARIABLE FLEX_INCLUDE_DIR)
pretty_print(VARIABLE FLEX_LIBRARIES)
pretty_print(VARIABLE FLEX_Lexer_OUTPUTS)

#-----------------------------------------------------------------------------
# Compile KPP source code into libKppSource.a
#-----------------------------------------------------------------------------
add_library(KppSource
  STATIC EXCLUDE_FROM_ALL
  ${BISON_Parser_OUTPUTS}
  ${FLEX_Lexer_OUTPUTS}
  ${CMAKE_CURRENT_BINARY_DIR}/code.h
  ${CMAKE_CURRENT_BINARY_DIR}/gdata.h
  ${CMAKE_CURRENT_BINARY_DIR}/gdef.h
  ${CMAKE_CURRENT_BINARY_DIR}/scan.h
  ${CMAKE_CURRENT_BINARY_DIR}/version.h
  ${CMAKE_CURRENT_BINARY_DIR}/code.c
  ${CMAKE_CURRENT_BINARY_DIR}/code_c.c
  ${CMAKE_CURRENT_BINARY_DIR}/code_f77.c
  ${CMAKE_CURRENT_BINARY_DIR}/code_f90.c
  ${CMAKE_CURRENT_BINARY_DIR}/code_matlab.c
  ${CMAKE_CURRENT_BINARY_DIR}/debug.c
  ${CMAKE_CURRENT_BINARY_DIR}/gen.c
  ${CMAKE_CURRENT_BINARY_DIR}/scanner.c
  ${CMAKE_CURRENT_BINARY_DIR}/scanutil.c
)

# KppSource depends on the Flex/Bison-generated code
target_link_libraries(KppSource
  PUBLIC
  ${FLEX_LIBRARIES}
)
