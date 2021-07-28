# kpp-code/CmakeLists.txt
# Defines KPP executable properties & location

#----------------------------------------------------------------------------
# Look for KPP source code in the ./src folder
#----------------------------------------------------------------------------
add_subdirectory(src)

#-----------------------------------------------------------------------------
# Specify the main program that will be built into the executable
#-----------------------------------------------------------------------------
set(EXE_FILE_NAME kpp
  CACHE STRING "Default name for the KPP-for-GEOS-Chem executable file"
)
mark_as_advanced(EXE_FILE_NAME)
add_executable(${EXE_FILE_NAME} src/kpp.c)

#-----------------------------------------------------------------------------
# Specify the libraries that the executable program depends on
#-----------------------------------------------------------------------------
target_link_libraries(${EXE_FILE_NAME}
  PUBLIC
  KppSource
  ${FLEX_LIBRARIES}
)

#-----------------------------------------------------------------------------
# Create the executable file in the bin subfolder of the buld directory
#-----------------------------------------------------------------------------
set_target_properties(${EXE_FILE_NAME}
  PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin
  )

#-----------------------------------------------------------------------------
# Copy the executable to this path when "make install" is run
#-----------------------------------------------------------------------------
install(TARGETS ${EXE_FILE_NAME} RUNTIME DESTINATION ${PROJECT_SOURCE_DIR}/bin)
