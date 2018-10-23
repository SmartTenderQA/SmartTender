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


def check_response(data):
    try:
        json = data['data']
    except KeyError:
        json = data
    return json


def create_monitoring(id, name):
    url = 'https://audit-api-sandbox.prozorro.gov.ua/api/2.4/monitorings'

    headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Basic OTk4N2I1NTE3MTBiNDQ2OTliZjJhZDEwMTg4YmNmNjU6',
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
    json = check_response(r.json())
    return json


def cancellation_monitoring(description, relatedParty, id):
    url = 'https://audit-api-sandbox.prozorro.gov.ua/api/2.4/monitorings' + '/' + str(id)

    headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Basic OTk4N2I1NTE3MTBiNDQ2OTliZjJhZDEwMTg4YmNmNjU6',
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
    json = check_response(r.json())
    return json


def get_monitoring_data(id, field=None, title=None):
    url = 'https://audit-api-sandbox.prozorro.gov.ua/api/2.4/monitorings/' + str(id)
    r = requests.get(url)

    if title is not None:
        n = 0
        l = r.json()['data'][field]
        for i in l:
            if i['title'] == title:
                break
            else:
                n += 1
        field = field + '.' + str(n)

    if field is not None:
        my_key = r.json()['data']
        for i in field.split('.'):
            try:
                i = int(i)
            except ValueError:
                pass
            else:
                i = int(i)
            my_key = my_key[i]
        return my_key
    else:
        return r.json()['data']


def decision(relatedParty, description, id):
    url = 'https://audit-api-sandbox.prozorro.gov.ua/api/2.4/monitorings/' + str(id)

    headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Basic OTk4N2I1NTE3MTBiNDQ2OTliZjJhZDEwMTg4YmNmNjU6',
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
    json = check_response(r.json())
    return json


def change_monitoring_status(status, id):
    url = 'https://audit-api-sandbox.prozorro.gov.ua/api/2.4/monitorings/' + str(id)

    headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Basic OTk4N2I1NTE3MTBiNDQ2OTliZjJhZDEwMTg4YmNmNjU6',
    }

    data = {
        "data": {
            "status": ""
        }
    }

    data['data']['status'] = status

    r = requests.patch(url, headers=headers, json=data)
    json = check_response(r.json())
    return json


def conclusion_true(violationOccurred, description, stringsAttached, auditFinding, id):
    url = 'https://audit-api-sandbox.prozorro.gov.ua/api/2.4/monitorings/' + str(id)

    headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Basic OTk4N2I1NTE3MTBiNDQ2OTliZjJhZDEwMTg4YmNmNjU6',
    }

    data = {
        "data": {
            "conclusion": {
                "violationType": [
                    "documentsForm",
                    "corruptionAwarded"
                ],
                "description": "",
                "stringsAttached": "",
                "auditFinding": "",
                "violationOccurred": ''
            }
        }
    }

    data['data']['conclusion']['violationOccurred'] = violationOccurred
    data['data']['conclusion']['description'] = description
    data['data']['conclusion']['stringsAttached'] = stringsAttached
    data['data']['conclusion']['auditFinding'] = auditFinding

    r = requests.patch(url, headers=headers, json=data)
    json = check_response(r.json())
    return json


def conclusion_false(violationOccurred, relatedParty, id):
    url = 'https://audit-api-sandbox.prozorro.gov.ua/api/2.4/monitorings/' + str(id)

    headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Basic OTk4N2I1NTE3MTBiNDQ2OTliZjJhZDEwMTg4YmNmNjU6',
    }

    data = {
        "data": {
            "conclusion": {
                "relatedParty": "",
                "violationOccurred": ''
            }
        }
    }

    data['data']['conclusion']['violationOccurred'] = violationOccurred
    data['data']['conclusion']['relatedParty'] = relatedParty

    r = requests.patch(url, headers=headers, json=data)
    json = check_response(r.json())
    return json


def eliminationResolution(relatedParty, description, id):
    url = 'https://audit-api-sandbox.prozorro.gov.ua/api/2.4/monitorings/' + str(id)

    headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Basic OTk4N2I1NTE3MTBiNDQ2OTliZjJhZDEwMTg4YmNmNjU6',
    }

    data = {
      "data": {
        "eliminationResolution": {
          "description": "",
          "relatedParty": "",
          "resultByType": {
            "corruptionAwarded": "not_eliminated",
            "documentsForm": "eliminated"
          },
          "result": "partly"
        }
      }
    }

    data['data']['eliminationResolution']['description'] = description
    data['data']['eliminationResolution']['relatedParty'] = relatedParty

    r = requests.patch(url, headers=headers, json=data)
    json = check_response(r.json())
    return json


def make_a_dialogue(title, description, relatedParty, id):
    url = 'https://audit-api-sandbox.prozorro.gov.ua/api/2.4/monitorings/' + str(id) + '/posts'

    headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Basic OTk4N2I1NTE3MTBiNDQ2OTliZjJhZDEwMTg4YmNmNjU6',
    }

    data = {
        "data": {
            "title": "",
            "relatedParty": "",
            "description": ""
        }
    }

    data['data']['title'] = str(title)
    data['data']['relatedParty'] = str(relatedParty)
    data['data']['description'] = str(description)

    r = requests.post(url, headers=headers, json=data)
    json = check_response(r.json())
    return json


def stopped(description, relatedParty, id):
    url = 'https://audit-api-sandbox.prozorro.gov.ua/api/2.4/monitorings/' + str(id)

    headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Basic OTk4N2I1NTE3MTBiNDQ2OTliZjJhZDEwMTg4YmNmNjU6',
    }

    data = {
        "data": {
            "status": "stopped",
            "cancellation": {
                "relatedParty": "",
                "description": ""
            }
        }
    }

    data['data']['cancellation']['relatedParty'] = str(relatedParty)
    data['data']['cancellation']['description'] = str(description)

    r = requests.patch(url, headers=headers, json=data)
    json = check_response(r.json())
    return json


def declined(description, relatedParty, id):
    url = 'https://audit-api-sandbox.prozorro.gov.ua/api/2.4/monitorings/' + str(id)

    headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Basic OTk4N2I1NTE3MTBiNDQ2OTliZjJhZDEwMTg4YmNmNjU6',
    }

    data = {
        "data": {
            "status": "stopped",
            "cancellation": {
                "relatedParty": "",
                "description": ""
            }
        }
    }

    data['data']['cancellation']['relatedParty'] = str(relatedParty)
    data['data']['cancellation']['description'] = str(description)

    r = requests.patch(url, headers=headers, json=data)
    json = check_response(r.json())
    return json


def inspection(description, monitoring_ids):
    url = 'https://audit-api-sandbox.prozorro.gov.ua/api/2.4/inspections'

    headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Basic OTk4N2I1NTE3MTBiNDQ2OTliZjJhZDEwMTg4YmNmNjU6',
    }

    data = {
        "data": {
            "description": "",
            "monitoring_ids": [
                ""
            ]
        }
    }

    data['data']['description'] = str(description)
    data['data']['monitoring_ids'][0] = str(monitoring_ids)

    r = requests.post(url, headers=headers, json=data)
    json = check_response(r.json())
    return json


def sas_answer(title, description, relatedParty, relatedPost, id):
    url = 'https://audit-api-sandbox.prozorro.gov.ua/api/2.4/monitorings/' + str(id) + '/posts'

    headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Basic OTk4N2I1NTE3MTBiNDQ2OTliZjJhZDEwMTg4YmNmNjU6',
    }

    data = {
        "data": {
            "title": "",
            "relatedParty": "",
            "relatedPost": "",
            "description": ""
        }
    }

    data['data']['title'] = str(title)
    data['data']['relatedParty'] = str(relatedParty)
    data['data']['relatedPost'] = str(relatedPost)
    data['data']['description'] = str(description)

    r = requests.post(url, headers=headers, json=data)
    json = check_response(r.json())
    return json
