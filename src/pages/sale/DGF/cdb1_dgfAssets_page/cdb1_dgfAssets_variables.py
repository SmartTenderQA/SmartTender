# -*- coding: utf-8 -*-


def get_edit_locators():
	return edit_locators

def get_view_locators():
	return view_locators

def get_data():
	return data


#<editor-fold desc="EDIT-LOCATORS">
edit_locators = {
	"dgfDecisionDate": u"//*[@id='pcModalMode_PW-1']//span[contains(text(), 'Дата')]/following-sibling::table//input",
	"dgfID": u"//*[@id='pcModalMode_PW-1']//span[contains(text(), 'Номер лоту')]/following-sibling::table//input",
	"dgfDecisionID": u"//*[contains(text(), 'Номер')]/following-sibling::table//input",
	"items": [
		{
			"quantity": u"//*[@id='pcModalMode_PW-1']//span[contains(text(), 'Кількість активів')]/following-sibling::*//input",
			"description": u"//*[@id='pcModalMode_PW-1']//span[contains(text(), 'Опис активу')]/following-sibling::*//input",
			"address": {
				"postalCode": u"//*[@id='pcModalMode_PW-1']//span[contains(text(), 'Індекс')]/following-sibling::table//input",
				"countryName": "",
				"streetAddress": u"//*[@id='pcModalMode_PW-1']//span[contains(text(), 'Вулиця')]/following-sibling::table//input",
				"locality": u"//*[@id='pcModalMode_PW-1']//span[contains(text(), 'Місто')]/following-sibling::*"
			}
		}
	],
	"title": u"//*[@id='pcModalMode_PW-1']//span[contains(text(), 'Загальна назва')]/following-sibling::table//input",
	"value": {
		"amount": u"//*[contains(text(), 'Ціна')]/following-sibling::table//input"
	},
	"description": u"//*[@id='pcModalMode_PW-1']//span[contains(text(), 'Детальний опис')]/following-sibling::table//textarea",
	"auctionPeriod": {
		"startDate": u"//*[contains(text(), 'День старту')]/following-sibling::table//input"
	},
	"guarantee": {
		"amount": "//*[@data-name='GUARANTEE_AMOUNT_PERCENT']//input"
	},
	"minimalStep": {
		"amount": "(//*[contains(text(), 'Мінімальний крок аукціону')]/following-sibling::table)[2]//input"
	}
}
#</editor-fold>


#<editor-fold desc="VIEW-LOCATORS">
view_locators = {
	"title": "//*[@class='ivu-col ivu-col-span-22']/h3",
	"dgfID": "//*[@class='ivu-col ivu-col-span-md-14']/h4",
	"auctionID": "//*[@data-qa='cdbNumber']",
	"description": "//*[@class='ivu-col ivu-col-span-md-14']//span",
	"value": {
		"amount": u"//*[contains(@class,'ivu-row') and contains(.,'Початкова вартість')]//*[contains(@class,'second')]",
		"valueAddedTaxIncluded": u"//*[contains(@class,'ivu-row') and contains(.,'Початкова вартість')]//*[contains(@class,'second')]",
	},
	"enquiryPeriod": {
		"startDate": u"//*[contains(@class,'ivu-row') and contains(.,'Період уточнень')]//*[contains(@class,'second')]",
		"endDate": u"//*[contains(@class,'ivu-row') and contains(.,'Період уточнень')]//*[contains(@class,'second')]"
	},
	"tenderPeriod": {
		"startDate": u"//*[contains(@class,'ivu-row') and contains(.,'Прийом пропозицій')]//*[contains(@class,'second')]",
		"endDate": u"//*[contains(@class,'ivu-row') and contains(.,'Прийом пропозицій')]//*[contains(@class,'second')]"
	},
	"auctionPeriod": {
		"startDate": u"//*[contains(@class,'ivu-row') and contains(.,'Початок аукціону')]//*[contains(@class,'second')]",
	},
	"dgfDecisionID": u"//*[contains(@class,'ivu-row') and contains(.,'рішення дирекції')]//*[contains(@class,'second')]",
	"dgfDecisionDate": u"//*[contains(@class,'ivu-row') and contains(.,'рішення дирекції')]//*[contains(@class,'second')]",
	"minimalStep": {
		"amount": u"//*[contains(@class,'ivu-row') and contains(.,'Мінімальний крок аукціону')]//*[contains(@class,'second')]",
	},
	"guarantee": {
		"amount": u"//*[contains(@class,'ivu-row') and contains(.,'Гарантійний внесок')]//*[contains(@class,'second')]"
	},
	"procuringEntity": {
		"identifier": {
			"legalName": u"//*[contains(@class,'ivu-row') and contains(.,'Назва')]//*[contains(@class,'second')]",
			"id": u"//*[contains(@class,'ivu-row') and contains(.,'Код ЄДРПОУ')]//*[contains(@class,'second')]",
		},
		"contactPoint": {
			"name": u"//*[contains(@class,'ivu-row') and contains(.,'ПІБ')]//*[contains(@class,'second')]",
			"telephone": u"//*[contains(@class,'ivu-row') and contains(.,'Телефон')]//*[contains(@class,'second')]",
			"email": u"//*[contains(@class,'ivu-row') and contains(.,'Email')]//*[contains(@class,'second')]",
		}
	},
	"items":
		[
			{
				"description": u"//*[contains(@class,'ivu-row') and contains(.,'Назва позиції')]//*[contains(@class,'second')]",
				"classification": {
					"description": u"//*[contains(@class,'ivu-row') and contains(.,'Класифікація')]//*[contains(@class,'second')]",
					"id": u"//*[contains(@class,'ivu-row') and contains(.,'Класифікація')]//*[contains(@class,'second')]",
					"scheme": u"//*[contains(@class,'ivu-row') and contains(.,'Класифікація')]//*[contains(@class,'second')]"
				},
				"unit": {
					"name": u"//*[contains(@class,'ivu-row') and contains(.,'Кількість')]//*[contains(@class,'second')]"
				},
				"quantity": u"//*[contains(@class,'ivu-row') and contains(.,'Кількість')]//*[contains(@class,'second')]",
				"address": {
					"postalCode": u"//*[contains(@class,'ivu-row') and contains(..,'Назва позиції') and contains(.,'Адреса')]//*[contains(@class,'second')]",
					"countryName": u"//*[contains(@class,'ivu-row') and contains(..,'Назва позиції') and contains(.,'Адреса')]//*[contains(@class,'second')]",
					"streetAddress": u"//*[contains(@class,'ivu-row') and contains(..,'Назва позиції') and contains(.,'Адреса')]//*[contains(@class,'second')]",
					"region": u"//*[contains(@class,'ivu-row') and contains(..,'Назва позиції') and contains(.,'Адреса')]//*[contains(@class,'second')]",
					"locality": u"//*[contains(@class,'ivu-row') and contains(..,'Назва позиції') and contains(.,'Адреса')]//*[contains(@class,'second')]",
				},
			},
		]
}
#</editor-fold>


#<editor-fold desc="DATA">
data = {
	"dgfDecisionDate": "",
	"dgfID": "",
	"dgfDecisionID": "",
	"items": [
		{
			"unit": {
				"name": ""
			},
			"quantity": "",
			"description": "",
			"classification": {
				"scheme": "",
				"description": "",
				"id": "",
			},
			"address": {
				"postalCode": "",
				"countryName": "",
				"streetAddress": "",
				"region": "",
				"locality": ""
			}
		}
	],
	"title": u"",
	"value": {
		"amount": ""
	},
	"description": "",
	"date": "",
	"guarantee": {
		"amount": ""
	},
	"minimalStep": {
		"amount": ""
	},
	"procuringEntity": {
		"contactPoint": {
			"name": ""
		}
	},
}
#</editor-fold>