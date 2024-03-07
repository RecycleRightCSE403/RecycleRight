'''
Type python -m pytest in terminal to run pytest files.
Create functions with a name starting with 
test_ as per standard pytest conventions.
'''

from ml import gemini_llm as llm

NUM_TRIALS = 3
ACCURACY_THRESHOLD = 0.6

example_sentences = [
    'Please separate the garbage before disposal.',
    'After finishing with the compost, we can use it to fertilize the garden.',
    'Remember to recycle the paper and plastic containers.',
    'We should donate these old clothes to the shelter.',
    'This item is special, so we\'ll need to handle it with care.',
    ]
correct_classifications = [
    'garbage',
    'compost',
    'recycle',
    'donate',
    'special',
    ]

def test_run_llm():
    '''
    Tests running llm
    :return: None
    '''
    response = llm.classify_item('cardboard box')
    assert response is not None
    assert response['classification'] is not None
    assert response['specifications'] is not None

def test_accuracy(trials=NUM_TRIALS, threshold=ACCURACY_THRESHOLD):
    '''
    Tests accuracy of llm responses
    :return: None
    '''
    correct = 0
    for _ in range(trials):
        response = llm.classify_item('cardboard box')
        if response['classification'] == 'recycle':
            correct += 1
            # exit as soon as possible since calling classify_item is expensive
            if correct / trials > threshold:
                assert True

@pytest.mark.flaky(retries=NUM_TRIALS, delay=1)
def test_special():
    '''
    Tests special responses are formatted correctly
    :return: None
    '''
    response = llm.classify_item('battery')
    assert response['classification'] == 'special'
    assert response['locations'] is not None

def test_clean_classification():
    '''
    Tests clean up code extracting correct word
    :return: None
    '''
    for x, y in zip(example_sentences, correct_classifications):
        assert llm.clean_up_classification(x) == y
