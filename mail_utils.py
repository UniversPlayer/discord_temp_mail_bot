import requests

BASE_URL = "https://api.mail.tm"

def generate_temp_email():
    # create account
    res = requests.post(
        f"{BASE_URL}/accounts",
        json={"address": None, "password": "discordbot123"}  # password can be anything
    )
    if res.status_code != 201:
        raise Exception("Failed to create email: " + res.text)

    account = res.json()
    email = account["address"]

    # login to get token
    login = requests.post(
        f"{BASE_URL}/token",
        json={"address": email, "password": "discordbot123"}
    )
    if login.status_code != 200:
        raise Exception("Failed to login: " + login.text)

    token = login.json()["token"]
    return email, token


def get_inbox(token):
    headers = {"Authorization": f"Bearer {token}"}
    res = requests.get(f"{BASE_URL}/messages", headers=headers)
    if res.status_code != 200:
        raise Exception("Failed to fetch inbox: " + res.text)

    return res.json().get("hydra:member", [])
