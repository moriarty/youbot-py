# Try to find SoQt library, against Qt3
# Once done this will define
#
# SOQT_LIBRARY_FOUND - If soqt is found
# SOQT_INCLUDE_DIR - where is the includes
# SOQT_LIBRARY_RELEASE - the release version
# SOQT_LIBRARY_DEBUG - the debug version
# SOQT_LIBRARY - a default library, with priority debug.
#
# This CMake finder is based in the job done 
# by Martin Wojtczyk <wojtczyk@in.tum.de> for 
# http://www.qiew.org
# 
# The modifications was done by
# Leopold Palomo <leo@alaxarxa.net>
# TODO: ensure that the soqt is linked against qt3
# with some test. Now _only_ search by the name
# works perfect with the debian version of soqt

FIND_PATH(SOQT_INCLUDE_DIR Inventor/Qt/SoQt.h
   ${CMAKE_INCLUDE_PATH}
   $ENV{COIN3DDIR}/include
   /usr/local/soqt/include
   /usr/local/SoQt/include
   /usr/local/include
   /usr/include
   $ENV{ProgramFiles}/SoQt-1/include
   $ENV{ProgramFiles}/Coin3D-2/include
   $ENV{COINDIR}/include
)

IF (SOQT_INCLUDE_DIR)
   MESSAGE(STATUS "Looking for SoQt headers -- found " ${SOQT_INCLUDE_DIR}/Inventor/Qt/SoQt.h)
      SET(SOQT_INCLUDE_DIR_FOUND 1 CACHE INTERNAL "SoQt headers found")
ELSE (SOQT_INCLUDE_DIR)
   MESSAGE(SEND_ERROR 
   "Looking for SoQt headers -- not found"
   "Please install SoQt http://www.coin3d.org/ or adjust CMAKE_INCLUDE_PATH"
   "e.g. cmake -DCMAKE_INCLUDE_PATH=/path-to-SoQt/include ...")
ENDIF (SOQT_INCLUDE_DIR)


FIND_LIBRARY(SOQT_LIBRARY_RELEASE
   NAMES SoQt3 soqt1 SoQt
   PATHS
   ${CMAKE_LIBRARY_PATH}
   $ENV{COIN3DDIR}/lib
   /usr/local/soqt/lib
   /usr/local/SoQt/lib
   /usr/local/lib
   /usr/lib
   $ENV{ProgramFiles}/SoQt-1/lib
   $ENV{ProgramFiles}/Coin3D-2/lib
   $ENV{COINDIR}/lib
)

FIND_LIBRARY(SOQT_LIBRARY_DEBUG
    NAMES SoQt3d SoQtd soqt1d 
    PATHS
    ${CMAKE_LIBRARY_PATH}
    $ENV{COIN3DDIR}/lib
    /usr/local/soqt/lib
    /usr/local/SoQt/lib
    /usr/local/lib
    /usr/lib/debug
    $ENV{ProgramFiles}/SoQt-1/lib
    $ENV{ProgramFiles}/Coin3D-2/lib
    $ENV{COINDIR}/lib
)

IF (SOQT_LIBRARY_RELEASE)
   MESSAGE(STATUS "Looking for SoQt library -- found " ${SOQT_LIBRARY_RELEASE})
ELSE (SOQT_LIBRARY_RELEASE)
   MESSAGE(SENDL_ERROR 
   "Looking for SoQt library -- not found"
   "Please install SoQt http://www.coin3d.org/ or adjust CMAKE_LIBRARY_PATH"
   "e.g. cmake -DCMAKE_LIBRARY_PATH=/path-to-SoQt/lib ..."
    "or try COIN3DDIR with the correct value")
ENDIF (SOQT_LIBRARY_RELEASE)

IF (SOQT_LIBRARY_DEBUG)
    MESSAGE(STATUS "Looking for SoQt library debug -- found " ${SOQT_LIBRARY_DEBUG})
ELSE (SOQT_LIBRARY_DEBUG)
    MESSAGE(STATUS 
    "Looking for SoQt library debug -- not found")
ENDIF (SOQT_LIBRARY_DEBUG)


IF (SOQT_LIBRARY_DEBUG AND SOQT_LIBRARY_RELEASE)
    # if the generator supports configuration types then set
    # optimized and debug libraries, or if the CMAKE_BUILD_TYPE has a value
    IF (CMAKE_CONFIGURATION_TYPES OR CMAKE_BUILD_TYPE)
      SET(SOQT_LIBRARY optimized ${SOQT_LIBRARY_RELEASE} debug ${SOQT_LIBRARY_DEBUG})
    ELSE(CMAKE_CONFIGURATION_TYPES OR CMAKE_BUILD_TYPE)
      # if there are no configuration types and CMAKE_BUILD_TYPE has no value
      # then just use the release libraries
      SET(SOQT_LIBRARY ${SOQT_LIBRARY_RELEASE} )
    ENDIF(CMAKE_CONFIGURATION_TYPES OR CMAKE_BUILD_TYPE)
    
    SET(SOQT_LIBRARIES optimized ${SOQT_LIBRARY_RELEASE} debug ${SOQT_LIBRARY_DEBUG})
ELSE(SOQT_LIBRARY_DEBUG AND SOQT_LIBRARY_RELEASE)
    # if have some lib or nothing
    IF(SOQT_LIBRARY_DEBUG)
       SET(SOQT_LIBRARY ${SOQT_LIBRARY_DEBUG})
    ENDIF(SOQT_LIBRARY_DEBUG)
    IF(SOQT_LIBRARY_RELEASE)
        SET(SOQT_LIBRARY ${SOQT_LIBRARY_RELEASE})
    ENDIF(SOQT_LIBRARY_RELEASE)
ENDIF (SOQT_LIBRARY_DEBUG AND SOQT_LIBRARY_RELEASE)

#SET(SOQT_LIBRARY_FOUND 1 CACHE INTERNAL "Coin3D library found")
IF(SOQT_INCLUDE_DIR AND SOQT_LIBRARY)
    SET(SOQT_LIBRARY_FOUND 1 CACHE INTERNAL "SoQt library found, ready to use")
ENDIF(SOQT_INCLUDE_DIR AND SOQT_LIBRARY)

MARK_AS_ADVANCED(
    SOQT_LIBRARY_FOUND
    SOQT_INCLUDE_DIR
    SOQT_LIBRARY
    SOQT_LIBRARY_RELEASE
    SOQT_LIBRARY_DEBUG
) 
