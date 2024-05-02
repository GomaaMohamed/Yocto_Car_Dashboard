############ Preamble ############
cmake_minimum_required(VERSION 3.22)
project(SomeIp_Communication)

# If necessary, you can set CMAKE_PREFIX_PATH
set(CMAKE_PREFIX_PATH "/usr/lib")

############# Project wide setup ################
list(APPEND CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR}/cmake)
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED YES)
set(CMAKE_CXX_EXTENSIONS NO)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++14 -g")
set(VSOMEIP_NAME "vsomeip3")
find_package(Threads REQUIRED)
find_package(${VSOMEIP_NAME} REQUIRED)
include_directories(${VSOMEIP_INCLUDE_DIRS})

# Add sub dirs
add_subdirectory(DashboardClient)
