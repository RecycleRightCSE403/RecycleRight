import main as backend
from fastapi import UploadFile
from io import BytesIO
import pytest

'''
Type python -m pytest in terminal to run pytest files.
Create functions with a name starting with 
test_ as per standard pytest conventions.
'''

IMAGE_DIRECTORY = 'images/'

def read_file(file_name, file_directory=IMAGE_DIRECTORY):
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
    text = 'cardboard box'
    response = await backend.classify_text(text)
    assert response is not None
    assert response['text'] is not None
    assert response['classification'] is not None
    assert response['text'] == text
