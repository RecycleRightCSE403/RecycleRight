import os
import requests
import base64

url = 'https://detect.roboflow.com/recycleright/1'
image_folder = 'images/'

api_key = os.environ.get('ROBOFLOW_API_KEY')
if api_key is None:
    raise Exception('ROBOFLOW_API_KEY environment variable does not exist')

def classify_image(image_file, image_folder=image_folder, api_key=api_key):
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


def get_highest_predictions(json_response, num_predictions=1):
    if len(json_response['predictions']) == 0:
        return []
    # Sorted by confidence, so 0 would be the highest confidence item
    #print(json_response['predictions'][0]['class'])
    classes = []
    for prediction in json_response['predictions'][:num_predictions]:
        classes.append(prediction['class'])

    return classes


r = classify_image('test2.jpeg')
print(r['image'])
print(get_highest_predictions(r))
