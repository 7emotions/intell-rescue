cmake_minimum_required(VERSION 3.12)
project(rescue VERSION 1.0 LANGUAGES C CXX)

# Set compilation flags
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_BUILD_TYPE "Debug")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=c11")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++2a")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -O3")

if(CMAKE_COMPILER_IS_GNUCXX OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    add_compile_options(-Wall -Wextra -Wpedantic)
endif()

set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

# Set configure_file
set (CONFIGURE_DIR_PATH ${PROJECT_SOURCE_DIR}/src)
# configure_file (
#         "${PROJECT_SOURCE_DIR}/src/config.h.in"
#         "${CONFIGURE_DIR_PATH}/config.h")

# Initialize custom options
# option (ENABLE_DEBUG_CANVAS "Enable debug canvas to draw debug image" ON)
# option (ENABLE_RECORDING "Enable recording of raw camera image" OFF)
# option (ENABLE_OPENVINO "Enable openvino to identify buff" ON)
# option (ENABLE_ROS "Enable ROS to visualize positions" ON)

set(EXECUTABLE_NAME ${PROJECT_NAME})

# Find non-ros packages
find_package(OpenCV 4.5 REQUIRED)

# Include project source directory
include_directories(${PROJECT_SOURCE_DIR}/src ${CONFIGURE_DIR_PATH})

# Recursively search for all source files under the 'src' folder and store them into AUTO_AIM_SOURCE variable
# Flag 'CONFIGURE_DEPENDS' asks cmake to detect GLOB result changes so no need to rerun cmake when adding a new source file.
file(GLOB_RECURSE AUTO_AIM_SOURCE CONFIGURE_DEPENDS ${PROJECT_SOURCE_DIR}/src/*.cpp)

add_executable(${EXECUTABLE_NAME}  ${AUTO_AIM_SOURCE})

# Link libraries
target_link_libraries(${EXECUTABLE_NAME} ${OpenCV_LIBS} -lpthread)

