# -*- coding: utf-8 -*-


dzk_locators = {
    "lotIdentifier": "//*[@data-qa='input-lotidentifier']//input",
	"title": "//*[@data-qa='input-title']//input",
	"description": "//*[@data-qa='input-description']//textarea",
	"lotHolder": {
		"identifier": {
			"legalName": "//*[@data-qa='input-organizer-title']//input",
			"id": "//*[@data-qa='input-asset-holder-usreouCode']//input",
		},
		"address": {
			"postalCode": "//*[@data-qa='component-asset-holder-address']//*[contains(@class,'span-sm-5')]//input",
			"locality": "//*[@data-qa='component-asset-holder-address']//*[contains(@class,'span-sm-10')]//input[@type='text']",
			"streetAddress": "//*[@data-qa='component-asset-holder-address']//*[@class='ivu-form-item ivu-form-item-required']//input",
		},
		"contactPoint": {
			"name": "//*[@data-qa='input-contact-person-name']//input",
			"email": "//*[@data-qa='button-contact-email']//input",
		},
	},
	"startdate": "//*[@class='ivu-date-picker']//input",
	"lots": "//*[contains(text(),'Лоти виставляються')]/following-sibling::*//input",
	"minNumberOfQualifiedBids": "//*[contains(text(),'Мінімальна кількість учасників аукціону')]/following-sibling::*//input",
	"222": "//*[@data-qa='input-years-count']//input",
	"333": "//*[@data-qa='input-months-count']//input",
	"value": {
		"amount": "//*[contains(text(),'Стартова ціна об’єкта')]/following-sibling::*//input[@type='text']",
	},
	"minimalStep": {
		"amount": "//*[contains(text(),'Крок електронного аукціону')]/following-sibling::*//input[@type='text']",
	},
	"guarantee": {
		"amount": "//*[contains(text(),'Розмір гарантійного внеску')]/following-sibling::*//input[@type='text']",
	},
	"budgetSpent": {
		"amount": "//*[contains(text(),'Вартість підготовки лоту до торгів')]/following-sibling::*//input[@type='text']",
	},
	"registrationFee": {
		"amount": "//*[contains(text(),'Реєстраційний внесок')]/following-sibling::*//input[@type='text']",
	},
	"bankAccount": {
		"bankName": "//*[contains(@class,'ivu-card-body') and contains(.,'Банківські реквізити')]/div[contains(@class,'required')]//input",
		"accountIdentification": {
			"0": {
				"description": "//*[@data-qa='BankName']//input",
				"id": "(//*[@data-qa='UsreouCode']//input)[3]",
			},
			"1": {
				"id": "(//*[@data-qa='Mfo'])[3]",
			},
			"2": {
				"id": "(//*[@data-qa='AccountNumber'])[3]",
			},
			"3": {
				"id": "(//*[@data-qa='UsreouCode']//input)[2]",
			},
			"4": {
				"id": "(//*[@data-qa='Mfo'])[2]",
			},
			"5": {
				"id": "(//*[@data-qa='AccountNumber'])[2]",
			},
			"6": {
				"id": "(//*[@data-qa='UsreouCode']//input)[1]",
			},
			"7": {
				"id": "(//*[@data-qa='Mfo'])[1]",
			},
			"8": {
				"id": "(//*[@data-qa='AccountNumber'])[1]",
			},
		},
	},
	"items": {
		"0": {
			"description": "//*[@data-qa='input-items-description']//textarea",
			"additionalClassifications": {
				"description": "//*[@data-qa='a-raise-additional-classification-modal']",
				"1": {
					"id": "//*[@data-qa='input-items-cadastralNumber']//input",
				}
			},
			"classification": {
				"description": "//*[@data-qa='a-raise-main-classification-modal']",
			},
			"quantity": "//*[@data-qa='input-item-count']//input",
			"unit": {
				"name": "//*[@data-qa='select-item-unit']",
			},
			"address": {
				"postalCode": "//*[@data-qa='component-item-address']",
				"locality": "//*[@data-qa='component-item-address']",
				"streetAddress": "//*[@data-qa='component-item-address']",
			},
		},
	},
}


dzk_data = {
    "lotIdentifier": "",
	"title": "",
	"description": "",
	"lotHolder": {
		"identifier": {
			"legalName": "",
			"id": "",
		},
		"address": {
			"postalCode": "",
			"locality": "",
			"streetAddress": "",
		},
		"contactPoint": {
			"name": "",
			"email": "",
		},
	},
	"startdate": "",
	"lots": "",
	"minNumberOfQualifiedBids": "",
	"222": "",
	"333": "",
	"value": {
		"amount": "",
	},
	"minimalStep": {
		"amount": "",
	},
	"guarantee": {
		"amount": "",
	},
	"budgetSpent": {
		"amount": "",
	},
	"registrationFee": {
		"amount": "",
	},
	"bankAccount": {
		"bankName": "",
		"accountIdentification": {
			"0": {
				"description": "",
				"id": "",
			},
			"1": {
				"id": "",
			},
			"2": {
				"id": "",
			},
			"3": {
				"id": "",
			},
			"4": {
				"id": "",
			},
			"5": {
				"id": "",
			},
			"6": {
				"id": "",
			},
			"7": {
				"id": "",
			},
			"8": {
				"id": "",
			},
		},
	},
	"items": {
		"0": {
			"description": "",
			"additionalClassifications": {
				"description": "",
				"1": {
					"id": "",
				}
			},
			"classification": {
				"description": "",
			},
			"quantity": "",
			"unit": {
				"name": "",
			},
			"address": {
				"postalCode": "",
				"locality": "",
				"streetAddress": "",
			},
		},
	},
}


