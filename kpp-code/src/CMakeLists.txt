# kpp-code/src/CMakeLists.txt
# Compiles KPP source code

#-----------------------------------------------------------------------------
# Use the parser (Bison) to create y.tab.c
# Use the scanner (Flex) to create lex.yy.c
#-----------------------------------------------------------------------------
BISON_TARGET(MyParser scan.y ${PROJECT_SOURCE_DIR}/kpp-code/src/y.tab.c)
FLEX_TARGET(MyScanner scan.l ${PROJECT_SOURCE_DIR}/kpp-code/src/lex.yy.c)
ADD_FLEX_BISON_DEPENDENCY(MyScanner MyParser)

#-----------------------------------------------------------------------------
# Compile source code into libKppSource.a using outputs from Bison & Flex
#-----------------------------------------------------------------------------
add_library(KppSource
  STATIC EXCLUDE_FROM_ALL

  # Header files
  code.h
  gdata.h
  gdef.h
  scan.h

  # C-language files
  ${BISON_MyParser_OUTPUTS}
  ${FLEX_MyScanner_OUTPUTS}
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
