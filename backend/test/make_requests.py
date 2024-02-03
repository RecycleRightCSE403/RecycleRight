import requests


def make_request(api_key):
    # Tells request to go and get information from that url
    base_url = "https://api.nasa.gov/neo/rest/v1/feed"
    response = requests.get(f'{base_url}?api_key={api_key}')
    return response
