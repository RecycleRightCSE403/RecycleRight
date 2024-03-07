'''
Type python -m pytest in terminal to run pytest files.
Create functions with a name starting with 
test_ as per standard pytest conventions.
'''

from io import BytesIO
import main as backend
from fastapi import UploadFile
import pytest

IMAGE_DIRECTORY = 'images/'

def read_file(file_name, file_directory=IMAGE_DIRECTORY):
    '''
    Reads in a file and returns expected input for backend api
    '''
    file_path = file_directory + file_name
    with open(file_path, 'rb') as file:
        contents = file.read()
    upload_file = UploadFile(
            filename=file_name,
            file=BytesIO(contents),
            )
    return upload_file

@pytest.mark.asyncio
async def test_classify_image():
    '''
    Tests classifying a normal image
    :return: None
    '''
    file_name = 'test1.jpeg'
    upload_file = read_file(file_name)
    response = await backend.classify_image_endpoint(upload_file)
    assert response is not None
    assert response['filename'] is not None
    assert response['text'] is not None
    assert response['classification'] is not None
    assert response['filename'] == file_name

@pytest.mark.asyncio
async def test_classify_empty_image():
    '''
    Tests classifying a black image
    :return: None
    '''
    file_name = 'black.jpg'
    upload_file = read_file(file_name)
    response = await backend.classify_image_endpoint(upload_file)
    assert response is not None
    assert response['filename'] is not None
    assert 'text' not in response
    assert response['classification'] is not None
    assert response['filename'] == file_name
    assert response['classification'] == 'Error'

@pytest.mark.asyncio
async def test_classify_text():
    '''
    Tests classifying from text instead of image
    :return: None
    '''
    text = 'cardboard box'
    response = await backend.classify_text(text)
    assert response is not None
    assert response['text'] is not None
    assert response['classification'] is not None
    assert response['text'] == text
