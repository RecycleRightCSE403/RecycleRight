from cv import classify

'''
Type python -m pytest in terminal to run pytest files.
Create functions with a name starting with 
test_ as per standard pytest conventions.
'''

sample_response = {
        'time': 0.06926758899953711,
        'image': {
            'width': 480,
            'height': 640},
        'predictions': [{
            'x': 243.0,
            'y': 347.0,
            'width': 474.0,
            'height': 462.0,
            'confidence': 0.759319543838501,
            'class': 'Corrugated carton',
            'class_id': 8,
            'detection_id': 'e2e59bc9-9eff-415c-8f8a-b133374aefd9'}]}

def test_run_model():
    response = classify.run_model('test2.jpeg')
    assert response['image']['width'] == 480
    assert response['image']['height'] == 640
    assert response['predictions'][0]['x'] == 194.0
    assert response['predictions'][0]['y'] == 251.0
    assert response['predictions'][0]['width'] == 270.0
    assert response['predictions'][0]['height'] == 178.0

def test_parse():
    classes = classify.parse_response(sample_response)
    assert len(classes) == 1
    assert classes[0] == 'Corrugated carton'

def test_parse_less_than_expected():
    classes = classify.parse_response(sample_response, max_predictions=2)
    assert len(classes) == 1
    assert classes[0] == 'Corrugated carton'

def test_parse_more_than_expected():
    classes = classify.parse_response(sample_response, max_predictions=0)
    assert len(classes) == 0

def test_classify_image():
    classes = classify.classify_image('test2.jpeg')
    assert len(classes) == 1
    assert classes[0] == 'Plastic film'

def test_classify_less_than_expected():
    classes = classify.classify_image('test2.jpeg', max_predictions=2)
    assert len(classes) == 1
    assert classes[0] == 'Plastic film'

def test_classify_more_than_expected():
    classes = classify.classify_image('test2.jpeg', max_predictions=0)
    assert len(classes) == 0

def test_classify_empty():
    classes = classify.classify_image('test3.jpeg')
    assert len(classes) == 0
