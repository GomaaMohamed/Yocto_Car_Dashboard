#ifndef DASHBOARD_CLIENT_
#define DASHBOARD_CLIENT_

#include <vsomeip/vsomeip.hpp>
#include <iostream>
#include <thread>
#include <chrono>
#include <cstring>
#include <string>
#include <sstream>
#include <iomanip>
#include <mutex>
#include <condition_variable>

// Speed Service
#define SPEED_SERVICE_ID 0x1234
#define SPEED_INSTANCE_ID 0x5678
#define SPEED_EVENTGROUP_ID 0x4465
#define SPEED_EVENT_ID 0x8778
// Temperature Service
#define TEMPERATURE_SERVICE_ID 0x1235
#define TEMPERATURE_INSTANCE_ID 0x5679
#define TEMPERATURE_EVENTGROUP_ID 0x4466
#define TEMPERATURE_EVENT_ID 0x8779
// Fuel Service
#define FUEL_SERVICE_ID 0x1233
#define FUEL_INSTANCE_ID 0x5677
#define FUEL_EVENTGROUP_ID 0x4463
#define FUEL_EVENT_ID 0x8773

class DashboardClient
{
public:
    DashboardClient();
    ~DashboardClient();
    bool initClient();
    void startClient();
    void sendSpeedRequest();
    static int getSpeedData();
    static int getTemperatureData();
    static int getFuelData();

private:
    std::shared_ptr<vsomeip::runtime> mSomeipRuntime;
    std::shared_ptr<vsomeip::application> mSomeipApplication;
    std::mutex mMutex;
    bool  mIsRunning;
    static int mSpeedData;
    static int mTemperatureData;
    static int mFuelData;
    std::condition_variable mCondition;
    void onMessageCallback(const std::shared_ptr<vsomeip::message> &Response);
    void onAvailabilityCallback(vsomeip::service_t Service, vsomeip::instance_t Instance, bool isAvailable);
    void onStateCallback(vsomeip::state_type_e State);
    void subscribeEvents();
};


#endif