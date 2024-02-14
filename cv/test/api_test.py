import classify

'''
Type python -m pytest in terminal to run pytest files.
Create functions with a name starting with 
test_ as per standard pytest conventions.
'''

def test_classify_image():
    json_response = classify.classify_image('test2.jpeg')
    classes = classify.get_highest_predictions(json_response)
    assert len(classes) == 1
    assert classes[0] == 'Plastic film'
