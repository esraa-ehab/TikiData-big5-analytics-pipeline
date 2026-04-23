import requests

url = "https://v3.football.api-sports.io/leagues"

payload={}
headers = {
  'x-apisports-key': '68cbc11ae9806f51bbebfc6bcf65feff',
}

response = requests.request("GET", url, headers=headers, data=payload)

print(response.text)