# -*- coding: utf-8 -*-

def get_edit_locators():
	return edit_locators

def get_view_locators():
	return view_locators

def get_data():
	return data


#<editor-fold desc="EDIT-LOCATORS">
edit_locators = {
    "assetID": u"//*[contains(text(),'Унікальний код')]/following-sibling::*//input",
    "decisions": [
        {
            "decisionDate": "//div[@class='ivu-input-wrapper ivu-input-type ivu-date-picker-editor']//input",
            "decisionID": u"(//h4[contains(., 'Рішення органу приватизації про затверждення умов продажу')]//following-sibling::*//input)[2]",
        }
    ],
    "auctions": [
        {
            "auctionPeriod": {
                "startDate": u"//*[contains(text(),'Дата проведення аукціону')]/following-sibling::*//input"
            },
            "value": {
                "amount": u"//*[contains(text(),'Стартова ціна об’єкта')]/following-sibling::*//input[@type='text']",
                "valueAddedTaxIncluded": "",
            },
            "minimalStep": {
                "amount": u"//*[contains(text(),'Крок аукціону')]/following-sibling::*//input[@type='text']",
                "valueAddedTaxIncluded": "",
            },
            "guarantee": {
                "amount": u"//*[contains(text(),'Розмір гарантійного внеску')]/following-sibling::*//input[@type='text']"
            },
            "registrationFee": {
                "amount": u"//*[contains(text(),'Реєстраційний внесок')]/following-sibling::*//input[@type='text']",
            },
            "bankAccount": {
                "bankName": u"//*[contains(text(),'Найменування банку')]/following-sibling::*//input",
                "accountIdentification": [
                    {
                        "scheme": u"//*[contains(text(),'Тип реквізиту')]/../following-sibling::*",
                        "id": u"//*[contains(text(),'Значення')]/../following-sibling::*//input",
                        "description": u"//*[contains(text(),'Опис')]/../following-sibling::*//input"
                    }
                ]
            }
        },
        {
            "tenderingDuration": u"//*[contains(text(),'Період між аукціонами')]/following-sibling::*//input",
            "auctionParameters": {
                "dutchSteps": u"//*[contains(text(),'Кількість кроків')]/following-sibling::*//input"
            },
        },
    ]
}
#</editor-fold>


#<editor-fold desc="VIEW-LOCATORS">
view_locators = {
    "assetID": "//*[@data-qa='cdbNumber']",
    "title": "//h3[not(@class='title')]",
    "description": "//*[@class='text-justify']/span",
    "decisions": [
        {
            "decisionDate": "(//*[@class='ivu-card-body' and contains(.,'Загальна інформація')]//*[@data-qa='value'])[2]",
            "decisionID": "(//*[@class='ivu-card-body' and contains(.,'Загальна інформація')]//*[@data-qa='value'])[2]",
            "title": "(//*[@class='ivu-card-body' and contains(.,'Загальна інформація')]//*[@data-qa='value'])[2]"
        }
    ],
    "assetCustodian": {
        "identifier": {
            "legalName": u"(//*[@class='ivu-card-body' and contains(.,'Орган приватизації')]//*[@data-qa='value'])[1]",
            "id": u"(//*[@class='ivu-card-body' and contains(.,'Орган приватизації')]//*[@data-qa='value'])[2]",
            "scheme": u"(//*[@class='ivu-card-body' and contains(.,'Орган приватизації')]//*[@data-qa='value'])[3]",
        },
        "contactPoint": {
            "name": u"(//*[@class='ivu-card-body' and contains(.,'Орган приватизації')]//*[@data-qa='value'])[5]",
            "telephone": u"(//*[@class='ivu-card-body' and contains(.,'Орган приватизації')]//*[@data-qa='value'])[6]",
            "email": u"(//*[@class='ivu-card-body' and contains(.,'Орган приватизації')]//*[@data-qa='value'])[7]",
        }
    },
    "items": [
            {
                "description": "(//*[@data-qa='item']//*[@data-qa='value'])[1]",
                "classification": {
                    "kind": "",
                    "description": "//*[@data-qa='item']//span[not(@data-qa) and not(@class)]",
                    "id": "//*[@data-qa='item']//span[not(@data-qa) and not(@class)]",
                    "scheme": "//*[@data-qa='item']//span[not(@data-qa) and not(@class)]"
                },
                "address": {
                    "postalCode": u"//*[@data-qa='item']//*[contains(@class,'ivu-row') and contains(.,'Адреса')]//*[@data-qa='value']",
                    "countryName": u"//*[@data-qa='item']//*[contains(@class,'ivu-row') and contains(.,'Адреса')]//*[@data-qa='value']",
                    "streetAddress": u"//*[@data-qa='item']//*[contains(@class,'ivu-row') and contains(.,'Адреса')]//*[@data-qa='value']",
                    "region": u"//*[@data-qa='item']//*[contains(@class,'ivu-row') and contains(.,'Адреса')]//*[@data-qa='value']",
                    "locality": u"//*[@data-qa='item']//*[contains(@class,'ivu-row') and contains(.,'Адреса')]//*[@data-qa='value']"
                },
                "unit": {
                    "name": u"//*[@data-qa='item']//*[contains(@class,'ivu-row') and contains(.,'Обсяг')]//*[@data-qa='value']"
                },
                "quantity": u"//*[@data-qa='item']//*[contains(@class,'ivu-row') and contains(.,'Обсяг')]//*[@data-qa='value']"
            }
        ],
}
#</editor-fold>


#<editor-fold desc="DATA">
data = {
    "decisions": [
        {
            "decisionDate": "",
            "decisionID": "",
        }
    ],
    "auctions": [
        {
            "auctionPeriod": {
                "startDate": ""
            },
            "value": {
                "amount": "",
                "valueAddedTaxIncluded": "",
            },
            "minimalStep": {
                "amount": "",
                "valueAddedTaxIncluded": "",
            },
            "guarantee": {
                "amount": ""
            },
            "registrationFee": {
                "amount": "",
            },
            "bankAccount": {
                "bankName": "",
                "accountIdentification": [
                {
                    "scheme": "",
                    "id": "",
                    "description": ""
                }
                ]
            }
        },
        {
            "tenderingDuration": "",
            "auctionParameters": {
                "dutchSteps": ""
            },
            "registrationFee": {
                "amount": "",
            },
            "bankAccount": {
                "bankName": "",
                "accountIdentification": [
                {
                    "scheme": "",
                    "id": "",
                    "description": ""
                }
                ]
            }
        },
        {
            "tenderingDuration": "",
            "registrationFee": {
                "amount": "",
            },
            "bankAccount": {
                "bankName": "",
                "accountIdentification": [
                {
                    "scheme": "",
                    "id": "",
                    "description": ""
                }
                ]
            }
        }
    ]
}
#</editor-fold>