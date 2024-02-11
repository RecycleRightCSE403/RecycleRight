import sys
import requests
import base64

url = 'https://detect.roboflow.com/recycleright/1'
image_folder = 'images/'

if len(sys.argv) != 3:
    print('Usage: python classify.py  <api_key> <image_file>')
    sys.exit(1)

api_key = sys.argv[1]
image_file = sys.argv[2]

try:
    with open(image_folder + image_file, 'rb') as image_file:
        image_data = image_file.read()
except FileNotFoundError:
    print(f'Error: file {image_file} not found')
    sys.exit(1)

image_base64 = base64.b64encode(image_data).decode('utf-8')
image_base64 = '\n'.join(image_base64[i:i+76] for i in range(0, len(image_base64), 76))

headers = { 'Content-Type': 'application/x-www-form-urlencoded' }

response = requests.post(url, data=image_base64, headers=headers, params={'api_key': api_key})

if not response.ok:
    print(f'{response.status_code} Error: {response.text}')
    sys.exit(1)

if len(response.json()['predictions']) == 0:
    print('Nothing found')

# Sorted by confidence, so 0 would be the highest confidence item
print(response.json()['predictions'][0]['class'])
