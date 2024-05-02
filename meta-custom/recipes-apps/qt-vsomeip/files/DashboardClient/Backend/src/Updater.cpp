#include "Updater.hpp"
#include "DashboardClient.hpp"

// Synchronize data with other threads
extern std::mutex its_mutex;
extern std::condition_variable its_cv;
extern bool its_received;

Updater::Updater(QQmlContext *context, QObject *parent) : QObject(parent), m_context(context)
{
    // Constructor implementation
}

void Updater::updateSpeed()
{
    while (true)
    {
        std::unique_lock<std::mutex> lock(its_mutex);
        its_cv.wait(lock, [](){ return its_received; });
        // Get speed data from Service class
        its_received = false;
        int speedData = static_cast<int>(DashboardClient::getSpeedData());
        int temperatureData = static_cast<int>(DashboardClient::getTemperatureData());
        int fuelData = static_cast<int>(DashboardClient::getFuelData());
        // Emit speedUpdated signal with the speed data
        emit speedUpdated(speedData);
        emit temperatureUpdated(temperatureData);
        emit fuelUpdated(fuelData);
    }

    // This code will never be reached due to the infinite loop
    emit finished();
}
