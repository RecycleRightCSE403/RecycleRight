from ml import gemini_llm as llm

'''
Type python -m pytest in terminal to run pytest files.
Create functions with a name starting with 
test_ as per standard pytest conventions.
'''

def test_run_llm():
    response = llm.classify_item('cardboard box')
    assert response is not None
    assert response['classification'] is not None
    assert response['specifications'] is not None

def test_accuracy(trials=5, threshold=0.6):
    correct = 0
    for _ in range(trials):
        response = llm.classify_item('cardboard box')
        if response['classification'] == 'recycle':
            correct += 1
    assert correct / trials > threshold
