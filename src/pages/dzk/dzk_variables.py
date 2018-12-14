# -*- coding: utf-8 -*-

###########################################################################
############################               ################################
############################ EDIT LOCATORS ################################
############################               ################################
###########################################################################
dzk_edit_locators = {
	"auctionID": "//*[@data-qa='cdbNumber']",
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
			"locality": "//*[@data-qa='component-asset-holder-address']//*[contains(@class,'span-sm-10')]",
			"streetAddress": "//*[@data-qa='component-asset-holder-address']//*[contains(text(),'Вулиця')]/following-sibling::*//input",
		},
		"contactPoint": {
			"name": "//*[@data-qa='input-contact-person-name']//input",
			"email": "//*[@data-qa='button-contact-email']//input",
		},
	},
	"auctionPeriod": {
		"shouldStartAfter": "//*[@class='ivu-date-picker']//input",
	},
	"tenderAttempts": u"//*[contains(text(),'Лоти виставляються')]/following-sibling::*//*[contains(@class,'ivu-select ')]",
	"minNumberOfQualifiedBids": u"//*[contains(text(),'Мінімальна кількість учасників аукціону')]/following-sibling::*//*[contains(@class,'ivu-select ')]",
	"contractTerms": {
    	"type": "",
    	"leaseTerms": {
			"years": "//*[@data-qa='input-years-count']//input",
			"months": "//*[@data-qa='input-months-count']//input",
    	}
  	},
	"value": {
		"amount": u"//*[contains(text(),'Стартова ціна об’єкта')]/following-sibling::*//input[@type='text']",
	},
	"minimalStep": {
		"amount": u"//*[contains(text(),'Крок електронного аукціону')]/following-sibling::*//input[@type='text']",
	},
	"guarantee": {
		"amount": u"//*[contains(text(),'Розмір гарантійного внеску')]/following-sibling::*//input[@type='text']",
	},
	"budgetSpent": {
		"amount": u"//*[contains(text(),'Вартість підготовки лоту до торгів')]/following-sibling::*//input[@type='text']",
	},
	"registrationFee": {
		"amount": u"//*[contains(text(),'Реєстраційний внесок')]/following-sibling::*//input[@type='text']",
	},
	"bankAccount": {
		"bankName": u"//*[contains(@class,'ivu-card-body') and contains(.,'Банківські реквізити')]/div[contains(@class,'required')]//input",
		"accountIdentification": [
			{
				"description": "//*[@data-qa='BankName']//input",
				"id": "(//*[@data-qa='UsreouCode']//input)[3]",
			},
			{
				"id": "(//*[@data-qa='Mfo']//input)[3]",
			},
			{
				"id": "(//*[@data-qa='AccountNumber']//input)[3]",
			},
			{
				"id": "(//*[@data-qa='UsreouCode']//input)[2]",
			},
			{
				"id": "(//*[@data-qa='Mfo']//input)[2]",
			},
			{
				"id": "(//*[@data-qa='AccountNumber']//input)[2]",
			},
			{
				"id": "(//*[@data-qa='UsreouCode']//input)[1]",
			},
			{
				"id": "(//*[@data-qa='Mfo']//input)[1]",
			},
			{
				"id": "(//*[@data-qa='AccountNumber']//input)[1]",
			},
		],
	},
	"items": [
		{
			"description": "//*[@data-qa='input-items-description']//textarea",
			"additionalClassifications": [
				{
					"description": "[contains(@data-qa,'additional-classification-modal')]",
				},
				{
					"id": "//*[@data-qa='input-items-cadastralNumber']//input",
				}
			],
			"classification": {
				"description": "[contains(@data-qa,'main-classification-modal')]",
			},
			"quantity": "//*[@data-qa='input-item-count']//input",
			"unit": {
				"name": "//*[@data-qa='select-item-unit']",
			},
			"address": {
				"postalCode": "//*[@data-qa='component-item-address']//*[contains(@class,'span-sm-5')]//input",
				"locality": "//*[@data-qa='component-item-address']//*[contains(@class,'span-sm-10')]",
				"streetAddress": "//*[@data-qa='component-item-address']//*[contains(text(),'Вулиця')]/following-sibling::*//input",
			},
		},
	],
}

###########################################################################
############################               ################################
############################ VIEW LOCATORS ################################
############################               ################################
###########################################################################
# dzk_view_locators = {
# 	"auctionID": "", #todo
#     "lotIdentifier": "//div[contains(@class,'span-md-14')]/h4",
# 	"title": "//div[contains(@class,'ivu-col')]/h3",
# 	"description": "//*[@class='text-justify']",
# 	"lotHolder": {
# 		"identifier": {
# 			"legalName": "(//*[contains(@class,'ivu-card-bordered') and contains(.,'Організатор')]//*[contains(@class,'16')])[1]",
# 			"id": "(//*[contains(@class,'ivu-card-bordered') and contains(.,'Організатор')]//*[contains(@class,'16')])[3]",
# 		},
# 		"address": {
# 			"postalCode": "(//*[contains(@class,'ivu-card-bordered') and contains(.,'Організатор')]//*[contains(@class,'16')])[4]",
# 			"locality": "(//*[contains(@class,'ivu-card-bordered') and contains(.,'Організатор')]//*[contains(@class,'16')])[4]",
# 			"streetAddress": "(//*[contains(@class,'ivu-card-bordered') and contains(.,'Організатор')]//*[contains(@class,'16')])[4]",
# 		},
# 		"contactPoint": {
# 			"name": "(//*[contains(@class,'ivu-card-bordered') and contains(.,'Організатор')]//*[contains(@class,'16')])[5]",
# 			"email": "(//*[contains(@class,'ivu-card-bordered') and contains(.,'Організатор')]//*[contains(@class,'16')])[7]",
# 		},
# 	},
# 	"tenderPeriod": {
# 		"endDate": "", #todo
# 	},
# 	"tenderAttempts": 0, #todo
# 	"minNumberOfQualifiedBids": 0,
# 	"years": "",
# 	"months": "",
# 	"value": {
# 		"amount": "",
# 	},
# 	"minimalStep": {
# 		"amount": "",
# 	},
# 	"guarantee": {
# 		"amount": "",
# 	},
# 	"budgetSpent": {
# 		"amount": "",
# 	},
# 	"registrationFee": {
# 		"amount": "",
# 	},
# 	"bankAccount": {
# 		"bankName": "",
# 		"accountIdentification": [
# 			{
# 				"description": "",
# 				"id": "",
# 			},
# 			{
# 				"id": "",
# 			},
# 			{
# 				"id": "",
# 			},
# 			{
# 				"id": "",
# 			},
# 			{
# 				"id": "",
# 			},
# 			{
# 				"id": "",
# 			},
# 			{
# 				"id": "",
# 			},
# 			{
# 				"id": "",
# 			},
# 			{
# 				"id": "",
# 			},
# 		],
# 	},
# 	"items": [
# 		{
# 			"description": "",
# 			"additionalClassifications": [
# 				{
# 				"description": "",
# 				},
# 				{
# 					"id": "",
# 				},
# 			],
# 			"classification": {
# 				"description": "",
# 			},
# 			"quantity": "",
# 			"unit": {
# 				"name": "",
# 			},
# 			"address": {
# 				"postalCode": "",
# 				"locality": "",
# 				"streetAddress": "",
# 			},
# 		},
# 	],
# }

###########################################################################
############################               ################################
############################      DATA     ################################
############################               ################################
###########################################################################
dzk_data = {
  "bankAccount": {
    "accountIdentification": [
      {
        "scheme": "UA-EDR",
        "id": "",
        "description": "[Реквізити рахунку (рахунків) виконавця для сплати винагороди та/або витрат на підготовку] Кишкатий доборотися обдарити.",
      },
      {
        "scheme": "UA-MFO",
        "id": "",
        "description": "[Реквізити рахунку (рахунків) виконавця для сплати винагороди та/або витрат на підготовку] Кишкатий доборотися обдарити.",
      },
      {
        "scheme": "accountNumber",
        "id": "",
        "description": "[Реквізити рахунку (рахунків) виконавця для сплати винагороди та/або витрат на підготовку] Кишкатий доборотися обдарити.",
      },
      {
        "scheme": "UA-EDR",
        "id": "",
        "description": "[Реквізити для перерахування гарантійних внесків]",
      },
      {
        "scheme": "UA-MFO",
        "id": "",
        "description": "[Реквізити для перерахування гарантійних внесків]",
      },
      {
        "scheme": "accountNumber",
        "id": "",
        "description": "[Реквізити для перерахування гарантійних внесків]",
      },
      {
        "scheme": "UA-EDR",
        "id": "",
        "description": "[Реквізити для перерахування реєстраційних внесків]",
      },
      {
        "scheme": "UA-MFO",
        "id": "",
        "description": "[Реквізити для перерахування реєстраційних внесків]",
      },
      {
        "scheme": "accountNumber",
        "id": "",
        "description": "[Реквізити для перерахування реєстраційних внесків]",
      }
    ],
    "bankName": "",
  },
  "auctionID": "",
  "minNumberOfQualifiedBids": "",
  "tenderPeriod": {
    "startDate": "",
    "endDate": "",
  },
  "rectificationPeriod": {
    "startDate": "",
    "endDate": "",
  },
  "enquiryPeriod": {
    "startDate": "",
    "endDate": "",
  },
  "registrationFee": {
    "currency": "UAH",
    "amount": "",
  },
  "title_en": "[TESTING] ",
  "lotHolder": {
    "contactPoint": {
      "email": "",
      "name": "",
      "telephone": "",
    },
    "identifier": {
      "scheme": "UA-EDR",
      "id": "",
      "legalName": "",
    },
    "name": "",
    "address": {
      "postalCode": "",
      "countryName": "Україна",
      "streetAddress": "",
      "region": "",
      "locality": "",
    }
  },
  "submissionMethod": "",
  "date": "",
  "procurementMethodType": "",
  "procuringEntity": {
    "contactPoint": {
      "email": "",
      "name": "",
      "telephone": "",
    },
    "identifier": {
      "scheme": "UA-EDR",
      "id": "",
      "legalName": "",
    },
    "name": "",
    "address": {
      "countryName": "Україна",
      "streetAddress": "",
      "region": "",
      "locality": "",
    }
  },
  "owner": "",
  "id": "",
  "budgetSpent": {
    "currency": "UAH",
    "amount": "",
    "valueAddedTaxIncluded": ""
  },
  "guarantee": {
    "currency": "UAH",
    "amount": "",
  },
  "lotIdentifier": "",
  "auctionPeriod": {
    "shouldStartAfter": "",
  },
  "contractTerms": {
    "type": "",
    "leaseTerms": {
      "leaseDuration": "",
		"years": "",
		"months": "",
    }
  },
  "title": "",
  "submissionMethodDetails": "",
  "items": [
    {
      "description": "",
      "classification": {
        "scheme": "",
        "id": "",
        "description": "",
      },
      "additionalClassifications": [
        {
          "scheme": "kvtspz",
          "id": "",
          "description": "",
        },
        {
          "scheme": "cadastralNumber",
          "id": "",
          "description": "Кадастровий номер",
        }
      ],
      "address": {
        "postalCode": "",
        "countryName": "Україна",
        "streetAddress": "",
        "region": "",
        "locality": "",
      },
      "id": "",
      "unit": {
        "code": "",
        "name": ""
      },
      "quantity": "",
    }
  ],
  "tenderAttempts": "",
  "description": "",
  "procurementMethod": "",
  "value": {
    "currency": "UAH",
    "amount": "",
    "valueAddedTaxIncluded": "",
  },
  "minimalStep": {
    "currency": "UAH",
    "amount": "",
    "valueAddedTaxIncluded": "",
  },
  "status": "",
  "mode": "test",
  "title_ru": "[ТЕСТИРОВАНИЕ] ",
  "procurementMethodDetails": "quick, accelerator=1440",
  "auctionParameters": {
    "type": "",
  },
  "dateModified": "",
  "awardCriteria": "",
}