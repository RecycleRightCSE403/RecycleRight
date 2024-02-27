import os
import base64
import requests
from dotenv import load_dotenv

# default paths
url = 'https://detect.roboflow.com/recycleright/1'
image_folder = 'images/'

# load api key from environment
# check if it is on the system
api_key = os.environ.get('ROBOFLOW_API_KEY')
# if not then load local variable from .env
if api_key is None:
    load_dotenv()
    api_key = os.environ.get('ROBOFLOW_API_KEY')
if api_key is None:
    raise Exception('ROBOFLOW_API_KEY environment variable does not exist')

def run_model(image_file, image_folder=image_folder, api_key=api_key):
    '''
    Returns the JSON response of runing the cv model on the image.
        
        Params:
            image_file (string): The name of the image file
            image_folder (string, optional): The name of the image directory.
                Defaults to "images/".
            api_key (string, optional): The api key used to call the Roboflow
                CV model. Defaults to the environment variable ROBOFLOW_API_KEY.

        Returns:
            dict: A JSON object containing the result of calling the CV model on
                the input image.

        Raises:
            FileNotFoundError: If image_file is not found in image_folder.
            Exception: If the CV model does not respond with code 200.
    '''
    try:
        with open(image_folder + image_file, 'rb') as image_file:
            image_data = image_file.read()
    except FileNotFoundError as e:
        print(f'Error: file {image_file} not found')
        raise e

    image_base64 = base64.b64encode(image_data).decode('utf-8')
    # api expects lines 76 characters long
    image_base64 = '\n'.join(image_base64[i : i + 76] for i in range(0, len(image_base64), 76))

    headers = { 'Content-Type': 'application/x-www-form-urlencoded' }

    response = requests.post(url, data=image_base64, headers=headers, params={'api_key': api_key})

    if not response.ok:
        raise Exception(f'{response.status_code} Error: {response.text}')

    return response.json()


def parse_response(json_response, max_predictions=1):
    '''
    Returns a list of predictions from a JSON response.

        Params:
            json_response (string): The JSON response from a call to the CV 
                model.
            max_predictions (int, optional): The maximum number of predictions
                that will be returned. Defaults to 1.

        Returns:
            list of string: The list of predictions from json_response with max 
                length max_predictions.
    '''
    if len(json_response['predictions']) == 0:
        return []
    # Sorted by confidence, so 0 would be the highest confidence item
    #print(json_response['predictions'][0]['class'])
    classes = []
    for prediction in json_response['predictions'][:max_predictions]:
        classes.append(prediction['class'])

    return classes

def classify_image(image_file, image_folder=image_folder, api_key=api_key, max_predictions=1):
    '''
    Returns a list of predictions from running the CV model on an image.

        Params:
            image_file (string): The name of the image file
            image_folder (string, optional): The name of the image directory.
                Defaults to "images/".
            api_key (string, optional): The api key used to call the Roboflow
                CV model. Defaults to the environment variable ROBOFLOW_API_KEY.
            max_predictions (int, optional): The maximum number of predictions
                that will be returned. Defaults to 1.

        Returns:
            list of string: The list of predictions from json_response with max 
                length max_predictions.

        Raises:
            FileNotFoundError: If image_file is not found in image_folder.
            Exception: If the CV model does not respond with code 200.
    '''
    return parse_response(run_model(image_file, image_folder, api_key), max_predictions)
