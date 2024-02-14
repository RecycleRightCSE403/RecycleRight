# RecycleRight

[![flutter-test](https://github.com/RecycleRightCSE403/RecycleRight/actions/workflows/flutter_test.yaml/badge.svg)](https://github.com/RecycleRightCSE403/RecycleRight/actions/workflows/flutter_test.yaml)

**[Requirements Document](https://docs.google.com/document/d/1-tRQytuJMfVyZsZzoSbtWy3YtfJzyljXGPqbyxGmIrc/edit?usp=sharing)**

### Beta Release!
> As of our beta release (2/13/2024), the app currently supports taking images and receiving a response about the waste type of the object
> in that image. This covers 2/5 of our Use Cases from our Requirements Document, including "Helping kids understand recycling" and "Use of
> the app within an average, busy Seattle family" albeit with various levels of accuracy. Our next steps will involve expanding the app to
> support all our use cases and increasing the accuracy of our algorithm.

## Overview

An Android app built to help you decide how to dipose of your trash. Simply
point your camera at whatever you need to dispose of and Recycle Right will 
quickly tell you how to do so, whether it be recyclable, compostible or garbage.

## Project Mission

We aim to simplify and educate about waste disposal, promoting sustainability and reducing waste mismanagement.

## Goals/Features

**RecycleRight** aims to achieve the following key objectives:

- **Efficient Waste Classification:** Use AI to classify items into categories (recycle, compost, landfill, etc.) using a phone's camera.
- **User Engagement:** Improve waste disposal habits through a user-friendly UI with engaging features. Allowing to report incorrect classifications.
- **Sustainability:** For items in good condition, include a suggestion to donate (with links to nearest donation centers).
  
# Repository Layout

## [Frontend](https://github.com/RecycleRightCSE403/RecycleRight/tree/main/frontend)

Contains the frontend of the app.

## [Backend](https://github.com/RecycleRightCSE403/RecycleRight/tree/main/backend)

Contains the backend of the app.

## [Backend/CV](https://github.com/RecycleRightCSE403/RecycleRight/tree/main/backend/cv)

Contains the CV model used to classify images.

## [Backend/ML](https://github.com/RecycleRightCSE403/RecycleRight/tree/main/backend/ml)

Contains the LLM used to provide disposal suggestions for items.

## Technology Stack

- **Frontend:** React Native / Flutter
- **Backend:** Python API (Django or FastAPI)
- **Hosting:** AWS (coming soon)
- **Machine Learning/Computer Vision:** Roboflow Object Detection, Mistral LLM
- **UI Design:** Figma

## Getting Started

### Installation

Requirements:
* Python >= 3.9
* Dart/Flutter
* Android Studio (for device emulation)

To run the app on an emulator in development mode (after following setup steps below):
1. Start a device emulator
2. Ensure that an environment variable is set as `ROBOFLOW_API_KEY=<secret>`
2. From the `backend` directory, run **`uvicorn main:app --reload`** to start the backend server
3. In another terminal window, cd to the `frontend/recycleright` dir and run **`flutter run`** to start the app

Modifications for running on a physical android device:
* Change the api IP address in frontend/recycleright/lib/results.dart to your local IP address
* Add `--host <YOUR_IP>` to the argument for the backend server

To run tests:
1. From the `frontend/recycleright` dir, run **`flutter test`**
2. From the `backend` dir, run **`python -m pytest`**

#### Backend

- Set up a Python virtual environment in `backend/venv/`
  - Use Python 3.9
- Install requirements using `pip install -r requirements.txt`
- Run the server with `uvicorn main:app --reload`

#### Frontend

- Install Flutter
  - run: '**flutter doctor**' follow steps if you don't have Flutter installed
- Install Dependencies
  -  Navigate to frontend/recycleright and run: '**flutter pub get**'
- Install [Andrioid Studio](https://developer.android.com/studio?gad_source=1&gclid=CjwKCAiAt5euBhB9EiwAdkXWO_ZQq0NscVbCKYvkMKEIa5Yb-NyTwmwuexwNaMiUe8hPTGaT3Ai9dhoCvagQAvD_BwE&gclsrc=aw.ds)
  - During installation, make sure to install the Android SDK and Android SDK Platform-Tools
- Add the Android SDK location to your PATH environment variable.
  - For mac:
  - For windows:
- Configure Android Emulator
  - Click 'More Actions' inside Andrioid Studio:
    - Click Virtual Device Manager and activate a device by clicking the green arrow (Pixel device should be default)
    - navigate to frontend/recycleright and now it should recognize the device when you run the app with: **'flutter run'**
- Troubleshooting:
  - Carefully follow any recommendations from 'flutter doctor'.
  - Use 'flutter devices' command while in frontend/recycleright to list devices
