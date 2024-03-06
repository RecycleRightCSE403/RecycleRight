"""
api_test.py
"""

import os

from fastapi import UploadFile
from fastapi.testclient import TestClient

from main import app

client = TestClient(app)

IMAGE_DIR = "images/"


def test_images():
    """
    Tests that the given images return the correct classification
    :return: None
    """
    cases = {
        'tire-large.jpg': 'garbage'
    }
    for img, ans in cases.items():
        with open(os.path.join(IMAGE_DIR, img), 'rb') as f:
            response = client.post('/classify_image/',
                                   files={'file': UploadFile(f).file})
        assert response.status_code == 200
        assert response.json()['classification']['classification'] == ans, \
            f'Expected {ans}, got {response.json()["classification"]} for {img}'


def test_text():
    """
    Tests that the text gets the correct classification
    :return: None
    """
    cases = {
        'battery': 'special'
    }
    for item, ans in cases.items():
        response = client.post('/classify_text/', json={'text': item})
        assert response.status_code == 200
        assert response.json()['classification']['classification'] == ans, \
            f'Expected {ans}, got {response.json()["classification"]} for {item}'
