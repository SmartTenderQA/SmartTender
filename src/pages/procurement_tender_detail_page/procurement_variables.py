# -*- coding: utf-8 -*-
#
# data     - для наполнения в него введенных даных
# locators - для получения локатора для конкретного значения словаря
import re
import sys

sys.path.append('../../src/')

from service import convert_datetime_to_smart_format


data = {
    "procurementMethod": "",
    "procedure-type": "",
    "numberOfBids": "",
    "awardPeriod": {
        "startDate": "",
        "endDate": ""
    },
    "complaintPeriod": {
        "startDate": "",
        "endDate": ""
    },
    "enquiryPeriod": {
        "startDate": "",
        "clarificationsUntil": "",
        "endDate": "",
        "invalidationDate": ""
    },
    "submissionMethod": "",
    "next_check": "",
    "awardCriteria": "",
    "owner": "",
    "title_en": "",
    "id": "",
    "tenderPeriod": {
        "startDate": "",
        "endDate": ""
    },
    "documents": [
        {
            "hash": "",
            "author": "",
            "language": "",
            "format": "",
            "url": "",
            "title": "",
            "documentOf": "",
            "datePublished": "",
            "dateModified": "",
            "id": ""
        }
    ],
    "questions": [
        {
            "date": "",
            "description": "",
            "id": "",
            "questionOf": "",
            "title": ""
        }
    ],
    "complaints": [
        {
            "status": "",
            "documents": [
                {
                    "hash": "",
                    "author": "",
                    "format": "",
                    "url": "",
                    "title": "",
                    "documentOf": "",
                    "datePublished": "",
                    "dateModified": "",
                    "id": ""
                }
            ],
            "description": "",
            "title": "",
            "dateSubmitted": "",
            "complaintID": "",
            "date": "",
            "type": "",
            "id": ""
        }
    ],
    "title": "",
    "auctionPeriod": {
        "startDate": "",
        "endDate": ""
    },
    "lots": [
        {
            "status": "",
            "description": "",
            "title": "",
            "minimalStep": {
                "currency": "",
                "amount": "",
                "valueAddedTaxIncluded": ""
            },
            "auctionPeriod": {
                "startDate": "",
                "shouldStartAfter": ""
            },
            "title_en": "",
            "description_en": "",
            "value": {
                "currency": "",
                "amount": "",
                "valueAddedTaxIncluded": ""
            },
            "date": "",
            "id": ""
        }
    ],
    "maxAwardsCount": "",
    "tenderID": "",
    "dateModified": "",
    "status": "",
    "description": "",
    "procurementMethodDetails": "",
    "procurementMethodType": "",
    "agreementDuration": "",
    "description_en": "",
    "date": "",
    "minimalStep": {
        "currency": "",
        "amount": "",
        "valueAddedTaxIncluded": ""
    },
    "awards": [
        {
            "status": "",
            "documents": [
                {
                    "hash": "",
                    "author": "",
                    "url": "",
                    "dateModified": "",
                    "format": "",
                    "title": "",
                    "id": "",
                    "documentOf": "",
                    "datePublished": ""
                },
            ],
        },
    ],
    "bids": [
        {
            "status": "",
            "documents": [
                {
                    "hash": "",
                    "author": "",
                    "url": "",
                    "dateModified": "",
                    "format": "",
                    "title": "",
                    "id": "",
                    "documentOf": "",
                    "datePublished": ""
                },
            ],
        },
    ],
    "contracts": [
        {
            "status": "",
            "documents": [
                {
                    "hash": "",
                    "author": "",
                    "url": "",
                    "dateModified": "",
                    "format": "",
                    "title": "",
                    "id": "",
                    "documentOf": "",
                    "datePublished": ""
                },
            ],
            "reason": "",
            "reasonType": "",
            "date": "",
            "cancellationOf": "",
            "id": ""
        },
    ],
    "items": [
        {
            "relatedLot": "",
            "description": "",
            "classification": {
                "scheme": "",
                "description": "",
                "id": ""
            },
            "description_en": "",
            "deliveryAddress": {
                "postalCode": "",
                "countryName": "",
                "streetAddress": "",
                "region": "",
                "locality": ""
            },
            "deliveryDate": {
                "startDate": "",
                "endDate": ""
            },
            "id": "",
            "unit": {
                "code": "",
                "name": ""
            },
            "quantity": ""
        }
    ],
    "value": {
        "currency": "",
        "amount": "",
        "valueAddedTaxIncluded": ""
    },
    "submissionMethodDetails": "",
    "mode": "",
    "title_ru": "",
    "procuringEntity": {
        "kind": "",
        "name": "",
        "address": {
            "postalCode": "",
            "countryName": "",
            "streetAddress": "",
            "region": "",
            "locality": ""
        },
        "contactPoint": {
            "name_en": "",
            "name": "",
            "availableLanguage": "",
            "email": ""
        },
        "identifier": {
            "scheme": "",
            "legalName_en": "",
            "id": "",
            "legalName": ""
        },
        "name_en": ""
    },
    "cancellations": [
        {
            "status": "",
            "documents": [
                {
                    "hash": "",
                    "author": "",
                    "url": "",
                    "dateModified": "",
                    "format": "",
                    "title": "",
                    "id": "",
                    "documentOf": "",
                    "datePublished": ""
                },
            ],
        },
    ],
    "qulification_documents": [

    ]
}

############################################ LOCATORS ###########################################


locators = {
    "procurementMethod": "",
    "procedure-type": """//*[@data-qa="procedure-type"]//div[2]""",
    "numberOfBids": "",
    "awardPeriod": {
        "startDate": "",
        "endDate": ""
    },
    "complaintPeriod": {
        "startDate": "",
        "endDate": ""
    },
    "enquiryPeriod": {
        "startDate": "",
        "clarificationsUntil": "",
        "endDate": """//*[@data-qa="enquiry-period"]//*[@data-qa="date-end"]""",
        "invalidationDate": ""
    },
    "submissionMethod": "",
    "next_check": "",
    "awardCriteria": "",
    "owner": "",
    "title_en": "",
    "id": """//*[@data-qa="prozorro-id"]//*[@data-qa="value"]""",
    "tenderPeriod": {
        "startDate": """//*[@data-qa="tendering-period"]//*[@data-qa="date-start"]""",
        "endDate": """//*[@data-qa="tendering-period"]//*[@data-qa="date-end"]"""
    },
    "documents": [
        {
            "hash": "",
            "author": "",
            "language": "",
            "format": "",
            "url": "",
            "title": "",
            "documentOf": "",
            "datePublished": "",
            "dateModified": "",
            "id": ""
        }
    ],
    "title": """//*[@data-qa="main-block"]//*[@data-qa="title"]""",
    "auctionPeriod": {
        "startDate": "",
        "endDate": ""
    },
    "lots": [
        {
            "status": "",
            "description": "",
            "title": "",
            "minimalStep": {
                "currency": "",
                "amount": "",
                "valueAddedTaxIncluded": ""
            },
            "auctionPeriod": {
                "startDate": "",
                "shouldStartAfter": ""
            },
            "title_en": "",
            "description_en": "",
            "value": {
                "currency": "",
                "amount": "",
                "valueAddedTaxIncluded": ""
            },
            "date": "",
            "id": ""
        }
    ],
    "maxAwardsCount": """//*[@data-qa="max-winner-count"]//*[@data-qa="value"]""",
    "tenderID": """//*[@data-qa="prozorro-number"]//a/span""",
    "dateModified": "",
    "status": """//*[@data-qa="status"]|//*[@data-qa="auctionStatus"]""",
    "description": """//*[@data-qa="main-block"]//*[@data-qa="description"]/span""",
    "procurementMethodDetails": "",
    "procurementMethodType": "",
    "agreementDuration": """(//*[@data-qa="agreement-duration"]//span)[2]""",
    "description_en": "",
    "date": "",
    "minimalStep": {
        "currency": "",
        "amount": """//*[@data-qa="budget-min-step"]//span[4]""",
        "valueAddedTaxIncluded": ""
    },
    "items": [
        {
            "relatedLot": "",
            "description": """//*[@data-qa="nomenclature-title"]""",
            "classification": {
                "scheme": "",
                "description": """//*[@data-qa="nomenclature-main-classification-title"]""",
                "id": """//*[@data-qa="nomenclature-main-classification-code"]"""
            },
            "description_en": "",
            "deliveryAddress": {
                "postalCode": """//*[@data-qa="nomenclature-delivery-address"]""",
                "countryName": "",
                "streetAddress": """//*[@data-qa="nomenclature-delivery-address"]""",
                "region": "",
                "locality": """//*[@data-qa="nomenclature-delivery-address"]"""
            },
            "deliveryDate": {
                "startDate": "",
                "endDate": ""
            },
            "id": "",
            "unit": {
                "code": "",
                "name": """//*[@data-qa="nomenclature-count"]"""
            },
            "quantity": """//*[@data-qa="nomenclature-count"]"""
        }
    ],
    "value": {
        "currency": "",
        "amount": """//*[@data-qa="budget-amount"]""",
        "valueAddedTaxIncluded": ""
    },
    "submissionMethodDetails": "",
    "mode": "",
    "title_ru": "",
    "procuringEntity": {
        "kind": "",
        "name": "",
        "address": {
            "postalCode": "",
            "countryName": "",
            "streetAddress": "",
            "region": "",
            "locality": ""
        },
        "contactPoint": {
            "name_en": "",
            "name": """//*[text()="Контактна особа"]/following-sibling::div//*[@data-qa="value"]""",
            "availableLanguage": "",
            "email": ""
        },
        "identifier": {
            "scheme": "R",
            "legalName_en": "",
            "id": "",
            "legalName": ""
        },
        "name_en": ""
    },
    "cancellations": [
        {
            "status": "",
            "documents": [
                {
                    "hash": "",
                    "author": "",
                    "url": "",
                    "dateModified": "",
                    "format": "",
                    "title": "",
                    "id": "",
                    "documentOf": "",
                    "datePublished": ""
                },
            ],
            "reason": "",
            "reasonType": "",
            "date": "",
            "cancellationOf": "",
            "id": ""
        },
    ]
}


docs_view = {
    "title": "//*[@data-qa='file-name']",
    "documentType": "//*[@data-qa='file-document-type']",
    "dateModified": "//*[@data-qa='file-date-modified']"
}


docs_data = {
    "key": "",
    "title": "",
    "hash": ""
}


def get_cdb_doc(doc, cdb_data):
    for i in cdb_data[doc['key']]:
        cdb_docs = i['documents']
        for i in cdb_docs:
            if doc['title'] == i['title']:
                result = i.copy()
                result['dateModified'] = convert_datetime_to_smart_format(i['dateModified'], 'm')
                return result


def get_cdb_fin_doc(doc, cdb_data):
    for i in cdb_data[doc['key']]:
        cdb_docs = i['financialDocuments']
        for i in cdb_docs:
            if doc['hash'] == i['hash']:
                result = i.copy()
                result['dateModified'] = convert_datetime_to_smart_format(i['dateModified'], 'm')
                return result


def get_locator(field):
    if "awards" in field:
        list = re.search('\[(?P<id>\d+)\](?P<path>.+)', field)
        id = int(list.group('id')) + 1
        result = list.group('path')
        map = {
        }
        if 'documents' in result:
            list = re.search('\[(?P<id>\d+)\](?P<path>.+)', result)
            doc_id = int(list.group('id')) + 1
            result = list.group('path')
            doc_map = {
                "['title']": u"""(//*[@data-qa="qualification-list"][{0}]//*[contains(text(),"Протокол")]/ancestor::div[3]//*[@data-qa="file-name"])[{1}-1]"""
            }
            return doc_map[result].format(id, doc_id)
        else:
            return map[result].format(id)
    elif "bids" in field:
        list = re.search('\[(?P<id>\d+)\](?P<path>.+)', field)
        id = int(list.group('id')) + 1
        result = list.group('path')
        map = {
            "['documents'][0]['title']": u"""//*[@data-qa="qualification-list"][{0}]//*[contains(text(),"вкладені на")]/ancestor::div[3]//*[@data-qa="file-name"]""",
            "['documents'][1]['title']": u"""//*[@data-qa="qualification-list"][{0}]//*[contains(text(),"вкладені на")]/ancestor::div[3]//*[@data-qa="file-name"]""",
            "['documents'][2]['title']": u"""//*[@data-qa="qualification-list"][{0}]//*[contains(text(),"вкладені на")]/ancestor::div[3]//*[@data-qa="file-name"]"""
        }
        if 'documents' in result:
            list = re.search('\[(?P<id>\d+)\](?P<path>.+)', result)
            doc_id = int(list.group('id')) + 1
            result = list.group('path')
            doc_map = {
                "['title']": u"""(//*[@data-qa="qualification-list"][{0}]//*[contains(text(),"вкладені на")]/ancestor::div[3]//*[@data-qa="file-name"])[{1}-1]"""
            }
            return doc_map[result].format(id, doc_id)
        else:
            return map[result].format(id)
    elif "contracts" in field:
        list = re.search('\[(?P<id>\d+)\](?P<path>.+)', field)
        id = int(list.group('id')) + 1
        result = list.group('path')
        map = {
            "['documents'][0]['title']": u"""//*[@data-qa="qualification-list"]//*[contains(text(),"Договір")]/ancestor::div[3]//*[@data-qa="file-name"]"""
        }
        return map[result].format(id)
    elif "questions" in field:
        list = re.search('\[(?P<id>\d+)\](?P<path>.+)', field)
        id = int(list.group('id')) + 1
        result = list.group('path')
        map = {
            "['title']": u"""(//*[@data-qa="questions"]//*[@class="bold break-word"])[last()-({0}-1)]""",
            "['description']": u"""(//*[@data-qa="questions"]//*[@class="ivu-card-body"])[last()-({0}-1)]//*[contains(@class,"card-padding")]""",
            "['answer']": u"""(//*[@data-qa="questions"]//*[contains(@class,"card-padding")])[last()-({0}-1)]"""
        }
        return map[result].format(id)
    elif "complaints" in field:
        list = re.search('\[(?P<id>\d+)\](?P<path>.+)', field)
        id = int(list.group('id')) + 1
        result = list.group('path')
        map = {
            "['title']": u"""(//*[@data-qa="complaint"]//*[@data-qa="title"]//*[@class="break-word"])[last()-({0}-1)]""",
            "['description']": u"""(//*[@data-qa="complaint"]//*[@data-qa="description"]//span/following-sibling::div)[last()-({0}-1)]""",
            "['documents'][0]['title']": u"""(//*[@data-qa="complaint"]//*[@data-qa="description"])[last()-({0}-1)]//a[text()]"""
        }
        return map[result].format(id)
    elif "cancellations" in field:
        list = re.search('\[(?P<id>\d+)\](?P<path>.+)', field)
        id = int(list.group('id')) + 1
        result = list.group('path')
        map = {
            "['reason']": u"""(//*[contains(@data-qa,"cancel")]//*[text()="Причина скасування"]/following-sibling::div[1])[{0}]""",
            "['documents'][0]['title']": u"""(//*[contains(@data-qa,"cancel")]//*[@data-qa="file-name"])[{0}]"""
        }
        return map[result].format(id)
