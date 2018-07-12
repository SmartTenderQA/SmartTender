#!/usr/bin/env python
# -*- coding: utf-8 -*-
# ==============
#      Main script file
# ==============
import sys
import requests
from datetime import datetime, timedelta


reload(sys)
sys.setdefaultencoding('utf-8')


def create_monitoring(id, name):
    url = 'https://audit-api-sandbox.prozorro.gov.ua/api/2.4/monitorings'

    headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Basic OWIzYWFhZmJhOWZlNGY0Yzk1YzNiZTNlMWZlYWFlMzE6',
    }

    data = {
        "data": {
            "mode": "test",
            "monitoringDetails": "accelerator=1440",
            "reasons": [
                "public",
                "fiscal",
            ],
            "tender_id": "",
            "procuringStages": [
                "awarding",
                "contracting"
            ],
            "parties": [
                {
                    "contactPoint": {
                        "name": "",
                        "telephone": "0440000000"
                    },
                    "identifier": {
                        "scheme": "UA-EDR",
                        "id": "40165856",
                        "uri": "http://www.dkrs.gov.ua"
                    },
                    "name": "The State Audit Service of Ukraine",
                    "roles": [
                        "sas"
                    ],
                    "address": {
                        "countryName": "Ukraine",
                        "postalCode": "04070",
                        "region": "Kyiv",
                        "streetAddress": "Petra Sahaidachnoho St, 4",
                        "locality": "Kyiv"
                    }
                }
            ]
        }
    }

    data['data']['tender_id'] = str(id)
    data['data']['parties'][0]['contactPoint']['name'] = str(name)

    r = requests.post(url, headers=headers, json=data)
    return r.json()


def cancellation_monitoring(description, relatedParty, id):
    url = 'https://audit-api-sandbox.prozorro.gov.ua/api/2.4/monitorings' + '/' + str(id)

    headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Basic OWIzYWFhZmJhOWZlNGY0Yzk1YzNiZTNlMWZlYWFlMzE6',
    }

    data = {
        "data": {
            "status": "cancelled",
            "cancellation": {
                "relatedParty": "",
                "description": ""
            }
        }
    }

    data['data']['cancellation']['description'] = description
    data['data']['cancellation']['relatedParty'] = relatedParty

    r = requests.patch(url, headers=headers, json=data)
    return r.json()


def get_monitoring_data(id, field=None):
    url = 'https://audit-api-sandbox.prozorro.gov.ua/api/2.4/monitorings/' + str(id)
    r = requests.get(url)

    if field == "parties.0.contactPoint.name":
        return r.json()['data']['parties'][0]['contactPoint']['name']

    elif field == "parties.0.id":
        return r.json()['data']['parties'][0]['id']

    elif field == "cancellation.description":
        return r.json()['data']['cancellation']['description']

    elif field is not None:
        return r.json()['data'][field]

    else:
        return r.json()['data']


def decision(relatedParty, description, id):
    url = 'https://audit-api-sandbox.prozorro.gov.ua/api/2.4/monitorings/' + str(id)

    headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Basic OWIzYWFhZmJhOWZlNGY0Yzk1YzNiZTNlMWZlYWFlMzE6',
    }

    data = {
        "data": {
            "decision": {
                "date": "",
                "relatedParty": "",
                "description": ""
            }
        }
    }

    now_date = datetime.now()
    date = now_date.strftime("%Y-%m-%dT%H:%M:%S")

    data['data']['decision']['date'] = date
    data['data']['decision']['relatedParty'] = relatedParty
    data['data']['decision']['description'] = description

    r = requests.patch(url, headers=headers, json=data)
    return r.json()


def change_monitoring_status(status, id):
    url = 'https://audit-api-sandbox.prozorro.gov.ua/api/2.4/monitorings/' + str(id)

    headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Basic OWIzYWFhZmJhOWZlNGY0Yzk1YzNiZTNlMWZlYWFlMzE6',
    }

    data = {
        "data": {
            "status": ""
        }
    }

    data['data']['status'] = status

    r = requests.patch(url, headers=headers, json=data)
    return r.json()
