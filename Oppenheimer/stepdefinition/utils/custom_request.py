import requests
import json

def send_post_request_to_insert_multiple_working_hero(base_url, uri, list_person):
    url = base_url + uri
    payload = json.dumps(list_person, default=vars)
    headers = {
        'Content-Type': 'application/json'
    }
    print(type(payload))
    response = requests.request("POST", url, headers=headers, data=payload)
    return response
