# RecycleRight

[![flutter-test](https://github.com/RecycleRightCSE403/RecycleRight/actions/workflows/flutter_test.yaml/badge.svg)](https://github.com/RecycleRightCSE403/RecycleRight/actions/workflows/flutter_test.yaml)

**[Requirements Document](https://docs.google.com/document/d/1-tRQytuJMfVyZsZzoSbtWy3YtfJzyljXGPqbyxGmIrc/edit?usp=sharing)**

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

## [CV](https://github.com/RecycleRightCSE403/RecycleRight/tree/main/cv)

Contains the CV model used to classify images.

## [ML](https://github.com/RecycleRightCSE403/RecycleRight/tree/main/ml)

Contains the LLM used to provide disposal suggestions for items.

## Technology Stack

- **Frontend:** React Native / Flutter
- **Backend:** Python API (Django or FastAPI)
- **Hosting:** AWS
- **Machine Learning/Computer Vision:** PyTorch, YOLOv7, OpenAI LLM
- **UI Design:** Figma

## Getting Started

### Installation

Instructions: Coming Soon

#### Backend

* Set up a Python virtual environment in `backend/venv/`
  * Use Python 3.9
* Install requirements using `pip install -r requirements.txt`
* Run the server with `uvicorn main:app --reload`