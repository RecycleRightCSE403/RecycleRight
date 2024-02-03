from make_requests import make_request

# type python -m pytest to run pytest files
# pytest will run all files of the form 
# test_*.py or *_test.py in the current directory and its subdirectories

# content of test_sample.py
def test_nasa_dataset_request():
    api_key = "DEMO_KEY"
    response = make_request(api_key)
    assert response.status_code == 200