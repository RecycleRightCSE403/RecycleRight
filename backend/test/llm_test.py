import pytest

from ml import gemini_llm as llm


@pytest.mark.flaky(retries=3, delay=1)
def test_keywords_with_response():
    cases = {
        'battery': 'special',
        'cardboard': 'recycle',
        'bananas': 'compost',
        'candy wrapper': 'garbage',
        'shirt': 'donate'
    }
    for item, ans in cases.items():
        response = llm.classify_item(item)
        assert response['classification'] == ans, f'Expected {ans}, got {response["classification"]} for {item}'
