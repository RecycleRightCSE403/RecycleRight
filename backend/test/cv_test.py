"""
cv_test.py
"""

from cv import classify


def test_images_with_response():
    """
    Tests that the images get the correct detected item
    :return: None
    """
    cases = {
        'test1.jpeg': 'paper',
        'test2.jpeg': 'metals_and_plastic',
        'test3.jpeg': 'metals_and_plastic',
        'test4.jpg': 'non_recyclable'
    }
    for img, ans in cases.items():
        classes = classify.classify_image(img)
        assert classes[0] == ans, f'got {classes[0]} and expected {ans} for {img}'


def test_images_success():
    """
    Tests that the images don't fail
    :return: None
    """
    cases = [
        'tire-small.jpg'
    ]
    for img in cases:
        classes = classify.classify_image(img)
        assert len(classes) > 0, f'got no items for {img}'


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
    """
    Tests output of run_model
    :return: None
    """
    response = classify.run_model('test2.jpeg')
    assert response['image']['width'] == 480
    assert response['image']['height'] == 640
    assert response['predictions'][0]['x'] == 180.0
    assert response['predictions'][0]['y'] == 308.0
    assert response['predictions'][0]['width'] == 180.0
    assert response['predictions'][0]['height'] == 120.0


def test_parse():
    """
    Tests parsing of response
    :return: None
    """
    classes = classify.parse_response(sample_response)
    assert len(classes) == 1
    assert classes[0] == 'Corrugated carton'


def test_parse_less_than_expected():
    """
    Tests parsing of response
    :return: None
    """
    classes = classify.parse_response(sample_response, max_predictions=2)
    assert len(classes) == 1
    assert classes[0] == 'Corrugated carton'


def test_parse_more_than_expected():
    """
    Tests parsing of response
    :return: None
    """
    classes = classify.parse_response(sample_response, max_predictions=0)
    assert len(classes) == 0


def test_classify_image():
    """
    Tests classifying image
    :return: None
    """
    classes = classify.classify_image('test2.jpeg')
    assert len(classes) == 1
    assert classes[0] == 'metals_and_plastic'


def test_classify_less_than_expected():
    """
    Tests classifying image
    :return: None
    """
    classes = classify.classify_image('test2.jpeg', max_predictions=10)
    assert len(classes) == 10
    assert classes[0] == 'metals_and_plastic'


def test_classify_more_than_expected():
    """
    Tests classifying image
    :return: None
    """
    classes = classify.classify_image('test2.jpeg', max_predictions=0)
    assert len(classes) == 0


def test_classify_empty():
    """
    Tests classifying image
    :return: None
    """
    classes = classify.classify_image('black.jpg')
    assert len(classes) == 0
