from cv import classify

'''
Type python -m pytest in terminal to run pytest files.
Create functions with a name starting with 
test_ as per standard pytest conventions.
'''

def test_classify_image():
    classes = classify.classify_image('test2.jpeg')
    assert len(classes) == 1
    assert classes[0] == 'Plastic film'
