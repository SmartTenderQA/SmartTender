# -*- coding: utf-8 -*-
#
# data     - для наполнения в него введенных даных
# locators - для получения локатора для конкретного значения словаря
import re


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
    }
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
                    "title": """//*[@data-qa="qualification-list"][1]//*[contains(text(),"Протокол")]/ancestor::div[3]//*[@data-qa="file-name"]""",
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
    }
}


def get_document_locator(field):
    if "awards" in field:
        list = re.search('\[(?P<id>\d)\](?P<path>.+)', field)
        award_id = int(list.group('id')) + 1
        result = list.group('path')
        map = {
            "['documents'][0]['title']": u"""//*[@data-qa="qualification-list"][{0}]//*[contains(text(),"Протокол")]/ancestor::div[3]//*[@data-qa="file-name"]"""
        }
        return map[result].format(award_id)
    elif "bids" in field:
        list = re.search('\[(?P<id>\d)\](?P<path>.+)', field)
        bids_id = int(list.group('id')) + 1
        result = list.group('path')
        map = {
            "['documents'][0]['title']": u"""//*[@data-qa="qualification-list"][{0}]//*[contains(text(),"вкладені на")]/ancestor::div[3]//*[@data-qa="file-name"]""",
            "['documents'][1]['title']": u"""//*[@data-qa="qualification-list"][{0}]//*[contains(text(),"вкладені на")]/ancestor::div[3]//*[@data-qa="file-name"]"""
        }
        return map[result].format(bids_id)
    elif "contracts" in field:
        list = re.search('\[(?P<id>\d)\](?P<path>.+)', field)
        contracts_id = int(list.group('id')) + 1
        result = list.group('path')
        map = {
            "['documents'][0]['title']": u"""//*[@data-qa="qualification-list"]//*[contains(text(),"Договір")]/ancestor::div[3]//*[@data-qa="file-name"]"""
        }
        return map[result].format(contracts_id)