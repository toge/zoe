# libGet-config.cmake - package configuration file

get_filename_component(SELF_DIR "${CMAKE_CURRENT_LIST_FILE}" PATH)

if(EXISTS ${SELF_DIR}/libGet-target.cmake)
	include(${SELF_DIR}/libGet-target.cmake)
endif()

if(EXISTS ${SELF_DIR}/libGet-static-target.cmake)
	include(${SELF_DIR}/libGet-static-target.cmake)
endif()
