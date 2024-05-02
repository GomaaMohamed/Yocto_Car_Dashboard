# Car Dashboard Deployment on QEMU using Yocto Project

This repository contains the necessary files and instructions to deploy a car dashboard application on QEMU using the Yocto Project. The dashboard application is developed using Qt/QML for the frontend and C++ for the backend. Additionally, it integrates vsomeip for interprocess communication.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Getting Started](#getting-started)
- [Running on QEMU](#running-on-qemu)
- [License](#license)

## Overview

In this project, We have developed a car dashboard application using Qt/QML for the frontend and C++ for the backend. The application communicates with various vehicle components using vsomeip, which provides interprocess communication capabilities.

## Prerequisites

Before you begin, ensure you have the following installed:

- [Yocto Project Requirements](https://docs.yoctoproject.org/ref-manual/system-requirements.html)

## Getting Started

To get started with deploying the car dashboard application, follow these steps:

1. Clone this repository with all included layers:

   ```bash
   git clone https://github.com/GomaaMohamed/Yocto_Car_Dashboard.git
2. Open a terminal inside poky
3. Start building (It will take several hours according to your network and machine)
   
   ```bash
   source oe-init-build-env ../qemu-build
   bitbake my-custom-image

## Running on QEMU

To run the generated image on qemu, follow these steps:

1. Inside the same terminal enter this command:

   ```bash
   runqemu

## License

This project is released under the GNU GPL License ↗. Feel free to use it in
your own projects, modify tit, and distribute it as needed. If you find any issues or have
suggestions for improvement, please open an issue or submit a pull request.

