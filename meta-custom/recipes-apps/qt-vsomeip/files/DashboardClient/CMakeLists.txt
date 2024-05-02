# Tell CMake to run the Qt tools moc, rcc, and uic automatically
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)
set(CMAKE_AUTOUIC ON)

# Configure Qt Paths
# If Qt6 is not found, you can manually specify the Qt6_DIR
set(Qt5_DIR "/usr/local/qt/lib/cmake/Qt5")

# If necessary, you can set CMAKE_PREFIX_PATH
set(CMAKE_PREFIX_PATH "/usr/lib")

# Find Qt6 components
find_package(Qt5 COMPONENTS Core Quick Gui Qml REQUIRED)

# Define an executable target
add_executable(dashboard_app)

# Extend the executable target
add_custom_command(TARGET dashboard_app POST_BUILD
    COMMAND echo "------- Built successfully ---------")

# Add the include directries for a target
target_include_directories(
    dashboard_app
    PRIVATE Backend/src
    PUBLIC Backend/include)

# Add the sources of the target
set(SRCS
    Backend/src/dashboardclient_main.cpp
    Backend/src/Updater.cpp
    Backend/src/DashboardClient.cpp
    qml.qrc)

# force cmake to generate a new header file contains the meta object
qt_wrap_cpp(SPEEDOMETER_MOC_SRCS Backend/include/Updater.hpp)

target_sources(
    dashboard_app
    PRIVATE ${SRCS}
    ${SPEEDOMETER_MOC_SRCS})

# Define the language standard
target_compile_features(
    dashboard_app
    PUBLIC cxx_std_17)
# tell cmake to link the executable to the Qt 6 core and test modules
target_link_libraries(dashboard_app
    PRIVATE
    Qt5::Core
    Qt5::Quick
    Qt5::Qml
    Qt5::Gui
    ${VSOMEIP_LIBRARIES} 
    ${CMAKE_THREAD_LIBS_INIT}
)
install(TARGETS dashboard_app RUNTIME DESTINATION /usr/bin)
install(FILES 
        ${CMAKE_SOURCE_DIR}/Configurations/speedservice.json
        ${CMAKE_SOURCE_DIR}/Configurations/dashboardclient.json
        ${CMAKE_SOURCE_DIR}/Configurations/temperatureservice.json
        ${CMAKE_SOURCE_DIR}/Configurations/fuelservice.json
        DESTINATION /usr/etc/vsomeip/Configurations
        PERMISSIONS OWNER_EXECUTE OWNER_WRITE OWNER_READ GROUP_EXECUTE GROUP_READ WORLD_EXECUTE WORLD_READ)

install(FILES ${CMAKE_SOURCE_DIR}/dashboard.service
        DESTINATION /lib/systemd/system
        PERMISSIONS OWNER_EXECUTE OWNER_WRITE OWNER_READ GROUP_EXECUTE GROUP_READ WORLD_EXECUTE WORLD_READ)

