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
# Use Bison to create Parser files: y.tab.c and y.tab.h
# Use Flex to creat Lexer files: lex.yy.c
# Make the Lexer depend on the Parser so that it can use Parser tokens
#-----------------------------------------------------------------------------
BISON_TARGET(Parser
  scan.y ${CMAKE_CURRENT_SOURCE_DIR}/y.tab.c
  COMPILE_FLAGS -d
  DEFINES_FILE ${CMAKE_CURRENT_SOURCE_DIR}/y.tab.h
)
FLEX_TARGET(Lexer
  scan.l ${CMAKE_CURRENT_SOURCE_DIR}/lex.yy.c
)
ADD_FLEX_BISON_DEPENDENCY(Lexer Parser)


# Print to
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
# Compile Flex/Bison generated code into libKppFlex.a
#-----------------------------------------------------------------------------
add_library(KppFlex
  STATIC EXCLUDE_FROM_ALL
  ${BISON_Parser_OUTPUTS}
  ${FLEX_Lexer_OUTPUTS}
)

#-----------------------------------------------------------------------------
# Compile KPP source code into libKppSource.a
#-----------------------------------------------------------------------------
add_library(KppSource
  STATIC EXCLUDE_FROM_ALL

  # Header files
  code.h
  gdata.h
  gdef.h
  scan.h
  version.h

  # C-language files
  code.c
  code_c.c
  code_f77.c
  code_f90.c
  code_matlab.c
  debug.c
  gen.c
  scanner.c
  scanutil.c
)

# KppSource depends on the Flex/Bison-generated code
target_link_libraries(KppSource
  PUBLIC
  KppFlex
)
