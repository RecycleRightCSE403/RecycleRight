from fastapi import FastAPI
from fastapi.testclient import TestClient
from main import app

'''
Type python -m pytest in terminal to run pytest files.
Create functions with a name starting with 
test_ as per standard pytest conventions.
'''

client = TestClient(app)

def test_read_item():
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == {
        "Hello": "World"
    }
 