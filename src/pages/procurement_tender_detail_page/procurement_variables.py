# -*- coding: utf-8 -*-
#
# data     - для на полнения в него введенных даных
# locators - для получения локатора для конкретного значения словаря


data = {
    "procurementMethod": "",
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
    "tender_uaid": "",
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
    "tender_uaid": """//*[@data-qa="prozorro-number"]//a/span""",
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
    "status": """//*[@data-qa="status"]|//*[@data-qa="auctionStatus"]""",
    "description": """//*[@data-qa="main-block"]//*[@data-qa="description"]/span""",
    "procurementMethodDetails": "",
    "procurementMethodType": "",
    "agreementDuration": "",
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
    }
}
