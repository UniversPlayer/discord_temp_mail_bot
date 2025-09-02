import requests
import random
import string

def generate_temp_email():
    login = ''.join(random.choices(string.ascii_lowercase + string.digits, k=10))
    domain = '1secmail.com'
    email = f"{login}@{domain}"
    return login, domain, email

def get_inbox(login, domain):
    url = f"https://www.1secmail.com/api/v1/?action=getMessages&login={login}&domain={domain}"
    response = requests.get(url)
    return response.json()
