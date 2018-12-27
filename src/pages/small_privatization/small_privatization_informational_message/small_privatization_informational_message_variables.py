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
    "lotID": "//*[@data-qa='cdbNumber']",
    "title": "//h3[not(@class='title')]",
    "description": "//*[@class='text-justify']/span",
    "decisions": [
        {
            "decisionDate": u"(//*[@class='ivu-card-body' and contains(.,'Загальна інформація')]//*[@data-qa='value'])[4]",
            "decisionID": u"(//*[@class='ivu-card-body' and contains(.,'Загальна інформація')]//*[@data-qa='value'])[4]",
        },
        {
            "decisionDate": u"(//*[@class='ivu-card-body' and contains(.,'Загальна інформація')]//*[@data-qa='value'])[3]",
            "decisionID": u"(//*[@class='ivu-card-body' and contains(.,'Загальна інформація')]//*[@data-qa='value'])[3]",
            "title": u"(//*[@class='ivu-card-body' and contains(.,'Загальна інформація')]//*[@data-qa='value'])[3]"
        }
    ],
    "auctions": [
        {
            "auctionPeriod": {
                "startDate": u"(//*[@class='ivu-card-body' and contains(.,'Умови')]//*[contains(@class,'second')])[3]"
            },
            "value": {
                "amount": u"(//*[@class='ivu-card-body' and contains(.,'Умови')]//*[contains(@class,'second')])[4]",
                "valueAddedTaxIncluded": u"(//*[@class='ivu-card-body' and contains(.,'Умови')]//*[contains(@class,'second')])[4]",
            },
            "minimalStep": {
                "amount": u"(//*[@class='ivu-card-body' and contains(.,'Умови')]//*[contains(@class,'second')])[5]",
                "valueAddedTaxIncluded": u"(//*[@class='ivu-card-body' and contains(.,'Умови')]//*[contains(@class,'second')])[5]",
            },
            "guarantee": {
                "amount": u"(//*[@class='ivu-card-body' and contains(.,'Умови')]//*[contains(@class,'second')])[6]"
            },
            "registrationFee": {
                "amount": u"(//*[@class='ivu-card-body' and contains(.,'Умови')]//*[contains(@class,'second')])[7]",
            },
            "bankAccount": {
                "bankName": u"(//*[@class='ivu-card-body' and contains(.,'Банківські реквізити')]//*[contains(@class,'second')]//span[@data-qa='value'])[1]",
                "accountIdentification": [
                {
                    "scheme": u"(//*[@class='ivu-card-body' and contains(.,'Банківські реквізити')]//*[contains(@class,'first')]//span)[2]",
                    "id": u"(//*[@class='ivu-card-body' and contains(.,'Банківські реквізити')]//*[contains(@class,'second')]//span[@data-qa='value'])[2]",
                }
                ]
            }
        },
        {
            "tenderingDuration": u"(//*[@class='ivu-card-body' and contains(.,'Умови')]//*[contains(@class,'second')])[10]",
            "value": {
                "amount": u"(//*[@class='ivu-card-body' and contains(.,'Умови')]//*[contains(@class,'second')])[11]",
                "valueAddedTaxIncluded": u"(//*[@class='ivu-card-body' and contains(.,'Умови')]//*[contains(@class,'second')])[11]",
            },
            "minimalStep": {
                "amount": u"(//*[@class='ivu-card-body' and contains(.,'Умови')]//*[contains(@class,'second')])[12]",
                "valueAddedTaxIncluded": u"(//*[@class='ivu-card-body' and contains(.,'Умови')]//*[contains(@class,'second')])[12]",
            },
            "guarantee": {
                "amount": u"(//*[@class='ivu-card-body' and contains(.,'Умови')]//*[contains(@class,'second')])[13]"
            },
            "registrationFee": {
                "amount": u"(//*[@class='ivu-card-body' and contains(.,'Умови')]//*[contains(@class,'second')])[14]",
            },
            "bankAccount": {
                "bankName": u"(//*[@class='ivu-card-body' and contains(.,'Банківські реквізити')]//*[contains(@class,'second')]//span[@data-qa='value'])[1]",
                "accountIdentification": [
                {
                    "scheme": u"(//*[@class='ivu-card-body' and contains(.,'Банківські реквізити')]//*[contains(@class,'first')]//span)[2]",
                    "id": u"(//*[@class='ivu-card-body' and contains(.,'Банківські реквізити')]//*[contains(@class,'second')]//span[@data-qa='value'])[2]",
                }
                ]
            }
        },
        {
            "tenderingDuration": u"(//*[@class='ivu-card-body' and contains(.,'Умови')]//*[contains(@class,'second')])[17]",
            "value": {
                "amount": u"(//*[@class='ivu-card-body' and contains(.,'Умови')]//*[contains(@class,'second')])[18]",
                "valueAddedTaxIncluded": u"(//*[@class='ivu-card-body' and contains(.,'Умови')]//*[contains(@class,'second')])[18]",
            },
            "guarantee": {
                "amount": u"(//*[@class='ivu-card-body' and contains(.,'Умови')]//*[contains(@class,'second')])[19]"
            },
            "registrationFee": {
                "amount": u"(//*[@class='ivu-card-body' and contains(.,'Умови')]//*[contains(@class,'second')])[20]",
            },
            "auctionParameters": {
                "dutchSteps": u"(//*[@class='ivu-card-body' and contains(.,'Умови')]//*[contains(@class,'second')])[21]"
            },
            "bankAccount": {
                "bankName": u"(//*[@class='ivu-card-body' and contains(.,'Банківські реквізити')]//*[contains(@class,'second')]//span[@data-qa='value'])[1]",
                "accountIdentification": [
                {
                    "scheme": u"(//*[@class='ivu-card-body' and contains(.,'Банківські реквізити')]//*[contains(@class,'first')]//span)[2]",
                    "id": u"(//*[@class='ivu-card-body' and contains(.,'Банківські реквізити')]//*[contains(@class,'second')]//span[@data-qa='value'])[2]",
                }
                ]
            }
        }
    ],
    "lotCustodian": {
        "identifier": {
            "legalName": u"(//*[@class='ivu-card-body' and contains(.,'Орган приватизації')]//*[contains(@class,'second')]//span[@data-qa='value'])[1]",
            "id": u"(//*[@class='ivu-card-body' and contains(.,'Орган приватизації')]//*[contains(@class,'second')]//span[@data-qa='value'])[2]",
            "scheme": u"(//*[@class='ivu-card-body' and contains(.,'Орган приватизації')]//*[contains(@class,'second')]//span[@data-qa='value'])[3]",
        },
        "contactPoint": {
            "name": u"(//*[@class='ivu-card-body' and contains(.,'Орган приватизації')]//*[contains(@class,'second')]//span[@data-qa='value'])[5]",
            "telephone": u"(//*[@class='ivu-card-body' and contains(.,'Орган приватизації')]//*[contains(@class,'second')]//span[@data-qa='value'])[6]",
            "email": u"(//*[@class='ivu-card-body' and contains(.,'Орган приватизації')]//*[contains(@class,'second')]//span[@data-qa='value'])[7]",
        }
    },
    "items": [
            {
                "description": "(//*[@data-qa='item']//*[@data-qa='value'])[1]",
                "classification": {
                    "description": "//*[@data-qa='item']//span[not(@data-qa) and not(@class)]",
                    "id": "//*[@data-qa='item']//span[not(@data-qa) and not(@class)]",
                    "scheme": "//*[@data-qa='item']//span[not(@data-qa) and not(@class)]"
                },
                "unit": {
                    "name": u"(//*[@data-qa='item']//*[@data-qa='value'])[2]"
                },
                "quantity": u"(//*[@data-qa='item']//*[@data-qa='value'])[2]",
                "address": {
                    "postalCode": u"(//*[@data-qa='item']//*[@data-qa='value'])[3]",
                    "countryName": u"(//*[@data-qa='item']//*[@data-qa='value'])[3]",
                    "streetAddress": u"(//*[@data-qa='item']//*[@data-qa='value'])[3]",
                    "region": u"(//*[@data-qa='item']//*[@data-qa='value'])[3]",
                    "locality": u"(//*[@data-qa='item']//*[@data-qa='value'])[3]"
                },
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
            "auctionParameters": {
                "dutchSteps": ""
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