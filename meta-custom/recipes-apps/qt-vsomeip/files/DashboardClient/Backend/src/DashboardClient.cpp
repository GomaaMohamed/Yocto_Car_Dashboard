#include "DashboardClient.hpp"

int DashboardClient::mSpeedData = 0;
int DashboardClient::mTemperatureData = 0;
int DashboardClient::mFuelData = 0;
// Synchronize data with other threads
std::mutex its_mutex;
std::condition_variable its_cv;
bool its_received = false;

DashboardClient::DashboardClient() : mSomeipRuntime(vsomeip::runtime::get()),
                                     mSomeipApplication(mSomeipRuntime->create_application()),
                                     mIsRunning(false)
{
}

DashboardClient::~DashboardClient() {}

bool DashboardClient::initClient()
{
    if (!mSomeipApplication->init())
    {
        std::cerr << "Couldn't initialize Dashboard application" << std::endl;
        return false;
    }

    // Register the state handler
    mSomeipApplication->register_state_handler(
        std::bind(&DashboardClient::onStateCallback, this, std::placeholders::_1));

    // Register the message handler for the speed service
    mSomeipApplication->register_message_handler(vsomeip::ANY_SERVICE, vsomeip::ANY_INSTANCE,
                                                 vsomeip::ANY_METHOD,
                                                 std::bind(&DashboardClient::onMessageCallback, this, std::placeholders::_1));

    // Register the availability handler
    mSomeipApplication->register_availability_handler(vsomeip::ANY_SERVICE, vsomeip::ANY_INSTANCE,
                                                      std::bind(&DashboardClient::onAvailabilityCallback, this,
                                                                std::placeholders::_1, std::placeholders::_2,
                                                                std::placeholders::_3));

    return true;
}

void DashboardClient::startClient()
{
    std::thread startClientsThread(&DashboardClient::subscribeEvents, this);
    startClientsThread.detach();
    mSomeipApplication->start();
}

void DashboardClient::sendSpeedRequest()
{
   
    std::shared_ptr<vsomeip::message> rq = mSomeipRuntime->create_request();
    rq->set_service(SPEED_SERVICE_ID);
    rq->set_instance(SPEED_INSTANCE_ID);
    rq->set_method(vsomeip::ANY_METHOD);
    mSomeipApplication->send(rq);

}

void DashboardClient::onMessageCallback(const std::shared_ptr<vsomeip::message> &Notification)
{
    if (Notification->get_service() == SPEED_SERVICE_ID &&
        Notification->get_instance() == SPEED_INSTANCE_ID &&
        Notification->get_method() == SPEED_EVENT_ID &&
        Notification->get_message_type() == vsomeip::message_type_e::MT_NOTIFICATION)
    {
        // Extract speed data from the payload
        std::shared_ptr<vsomeip::payload> payload = Notification->get_payload();
        if (payload->get_length() == sizeof(int))
        {
            int speed;
            std::memcpy(&speed, payload->get_data(), sizeof(int));
            std::cout << "Received speed notification: " << speed << std::endl;
            // Now you can update your dashboard with the received speed data
            std::lock_guard<std::mutex> guard(its_mutex);
            mSpeedData = speed;
            its_received = true;
            its_cv.notify_one();
        }
    }
    else if (Notification->get_service() == TEMPERATURE_SERVICE_ID &&
             Notification->get_instance() == TEMPERATURE_INSTANCE_ID &&
             Notification->get_method() == TEMPERATURE_EVENT_ID &&
             Notification->get_message_type() == vsomeip::message_type_e::MT_NOTIFICATION)
    {
        // Extract speed data from the payload
        std::shared_ptr<vsomeip::payload> payload = Notification->get_payload();
        if (payload->get_length() == sizeof(int))
        {
            int temperature;
            std::memcpy(&temperature, payload->get_data(), sizeof(int));
            std::cout << "Received temperature notification: " << temperature << std::endl;
            // Now you can update your dashboard with the received speed data
            std::lock_guard<std::mutex> guard(its_mutex);
            mTemperatureData = temperature;
            its_received = true;
            its_cv.notify_one();
        }
    }
    else if (Notification->get_service() == FUEL_SERVICE_ID &&
             Notification->get_instance() == FUEL_INSTANCE_ID &&
             Notification->get_method() == FUEL_EVENT_ID &&
             Notification->get_message_type() == vsomeip::message_type_e::MT_NOTIFICATION)
    {
        // Extract speed data from the payload
        std::shared_ptr<vsomeip::payload> payload = Notification->get_payload();
        if (payload->get_length() == sizeof(int))
        {
            int fuel;
            std::memcpy(&fuel, payload->get_data(), sizeof(int));
            std::cout << "Received fuel notification: " << fuel << std::endl;
            // Now you can update your dashboard with the received speed data
            std::lock_guard<std::mutex> guard(its_mutex);
            mFuelData = fuel;
            its_received = true;
            its_cv.notify_one();
        }
    }
    else
    {
        std::cerr << "Received unexpected message" << std::endl;
    }
}

void DashboardClient::onAvailabilityCallback(vsomeip::service_t _service, vsomeip::instance_t _instance, bool _is_available)
{
    std::cout << "CLIENT: Service ["
              << std::setw(4) << std::setfill('0') << std::hex << _service << "." << _instance
              << "] is "
              << (_is_available ? "available." : "NOT available.")
              << std::endl;
    //std::lock_guard<std::mutex> guard(mMutex);
    mCondition.notify_one();
}
void DashboardClient::onStateCallback(vsomeip::state_type_e State)
{
    if (State == vsomeip::state_type_e::ST_REGISTERED)
    {
        // Request the speed service
        mSomeipApplication->request_service(SPEED_SERVICE_ID, SPEED_INSTANCE_ID);
        // Request the temperature service
        mSomeipApplication->request_service(TEMPERATURE_SERVICE_ID, TEMPERATURE_INSTANCE_ID);
        // Request the fuel service
        mSomeipApplication->request_service(FUEL_SERVICE_ID, FUEL_INSTANCE_ID);
    }
}

void DashboardClient::subscribeEvents()
{
    std::unique_lock<std::mutex> its_lock(mMutex);
    mCondition.wait(its_lock);
    // Request speed
    std::set<vsomeip::eventgroup_t> its_groups;
    its_groups.insert(SPEED_EVENTGROUP_ID);
    mSomeipApplication->request_event(SPEED_SERVICE_ID, SPEED_INSTANCE_ID, SPEED_EVENT_ID, its_groups);
    mSomeipApplication->subscribe(SPEED_SERVICE_ID, SPEED_INSTANCE_ID, SPEED_EVENTGROUP_ID);
    // Request temperature
    its_groups.insert(TEMPERATURE_EVENTGROUP_ID);
    mSomeipApplication->request_event(TEMPERATURE_SERVICE_ID, TEMPERATURE_INSTANCE_ID, TEMPERATURE_EVENT_ID, its_groups);
    mSomeipApplication->subscribe(TEMPERATURE_SERVICE_ID, TEMPERATURE_INSTANCE_ID, TEMPERATURE_EVENTGROUP_ID);
    // Request fuel
    its_groups.insert(FUEL_EVENTGROUP_ID);
    mSomeipApplication->request_event(FUEL_SERVICE_ID, FUEL_INSTANCE_ID, FUEL_EVENT_ID, its_groups);
    mSomeipApplication->subscribe(FUEL_SERVICE_ID, FUEL_INSTANCE_ID, FUEL_EVENTGROUP_ID);
}

int DashboardClient::getSpeedData()
{
    return mSpeedData;
}

int DashboardClient::getTemperatureData()
{
    return mTemperatureData;
}
int DashboardClient::getFuelData()
{
    return mFuelData;
}