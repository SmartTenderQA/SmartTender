# -*- coding: utf-8 -*-

def get_edit_locators():
	return edit_locators

def get_view_locators():
	return view_locators

def get_data():
	return data


#<editor-fold desc="EDIT-LOCATORS">
edit_locators = {
        "title": "//*[@data-qa='input-title']//*[@autocomplete='off']",
        "description": u"//*[@data-qa='input-description']//*[@autocomplete='off']",
        "items": [
            {
                "description": "//*[@data-qa='input-items-description']//*[@autocomplete='off']",
                "classification": {
                    "kind": "//*[@data-qa='select-items-object-kind']",
                    "description": "[contains(@data-qa,'main-classification-modal')]",
                },
                "address": {
                    "postalCode": "//div[contains(@class,'address-label') and not(contains(@class,'offset '))]//input[@type='text']",
                    "countryName": "//div[@class='ivu-col ivu-col-span-sm-9']",
                    "streetAddress": "//*[@data-qa='component-item-address']/div[contains(@class,'ivu-form-item-required')]//input",
                    "locality": "//div[@class='ivu-col ivu-col-span-sm-10']//div[@class='ivu-form-item-content']"
                },
                "unit": {
                    "name": "//*[@data-qa='select-item-unit']"
                },
                "quantity": "//*[@data-qa='input-item-count']//*[@autocomplete='off']"
            }
        ],
        "decisions": [
            {
                "decisionDate": "//*[@data-qa='datepicker-decision-date']//*[@autocomplete='off']",
                "decisionID": "//*[@data-qa='input-decision-number']//*[@autocomplete='off']",
                "title": "//*[@data-qa='input-decision-title']//*[@autocomplete='off']"
            }
        ],
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
        "title": "",
        "description": "",
        "items": [
            {
                "description": "",
                "classification": {
                    "kind": "",
                    "description": "",
                    "id": ""
                },
                "address": {
                    "postalCode": "",
                    "countryName": "",
                    "streetAddress": "",
                    "region": "",
                    "locality": ""
                },
                "unit": {
                    "name": ""
                },
                "quantity": ""
            }
        ],
        "decisions": [
            {
                "decisionDate": "",
                "decisionID": "",
                "title": ""
            }
        ],
}
#</editor-fold>