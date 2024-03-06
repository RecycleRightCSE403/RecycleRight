import os

from fastapi import UploadFile
from fastapi.testclient import TestClient

from main import app

client = TestClient(app)

IMAGE_DIR = "images/"


def test_images():
    # add test cases here in image: classification format
    cases = {
        'tire-large.jpg': 'garbage'
    }
    for img, ans in cases.items():
        response = client.post('/classify_image/',
                               files={'file': UploadFile(open(os.path.join(IMAGE_DIR, img), 'rb')).file})
        assert response.status_code == 200
        assert response.json()['classification']['classification'] == ans, \
            f'Expected {ans}, got {response.json()["classification"]} for {img}'


def test_text():
    # add test cases here in item: classification format
    cases = {
        'battery': 'special'
    }
    for item, ans in cases.items():
        response = client.post('/classify_text/', json={'text': item})
        assert response.status_code == 200
        assert response.json()['classification']['classification'] == ans, \
            f'Expected {ans}, got {response.json()["classification"]} for {item}'
