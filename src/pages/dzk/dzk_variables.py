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
##########################################################################
###########################               ################################
########################### VIEW LOCATORS ################################
###########################               ################################
##########################################################################
dzk_view_locators = {
	"auctionID": "//*[@data-qa='cdbNumber']",
	"lotIdentifier": "//*[@class='ivu-col ivu-col-span-md-14']/h4",
	"title": "//*[@class='ivu-col ivu-col-span-22']/h3",
	"description": "//*[@class='ivu-col ivu-col-span-md-14']//span",
	"lotHolder": {
		"identifier": {
			"legalName": u"(//*[@class='ivu-card-body' and contains(.,'Організатор')]//*[@data-qa])[1]",
			"id": u"(//*[@class='ivu-card-body' and contains(.,'Організатор')]//*[@data-qa])[3]",
		},
		"address": {
			"postalCode": u"(//*[@class='ivu-card-body' and contains(.,'Організатор')]//*[@data-qa])[4]",
			"region": u"(//*[@class='ivu-card-body' and contains(.,'Організатор')]//*[@data-qa])[4]",
			"locality": u"(//*[@class='ivu-card-body' and contains(.,'Організатор')]//*[@data-qa])[4]",
			"streetAddress": u"(//*[@class='ivu-card-body' and contains(.,'Організатор')]//*[@data-qa])[4]",
		},
		"contactPoint": {
			"name": u"(//*[@class='ivu-card-body' and contains(.,'Організатор')]//*[@data-qa])[5]",
			"email": "//*[contains(@href,'mailto') and not(contains(text(),'smart'))]",
		},
	},
	"auctionPeriod": {
		"shouldStartAfter": "//span[@class='info_dtauction']",
	},
	"tenderAttempts": u"", #todo
	"minNumberOfQualifiedBids": u"//*[contains(@class,'margin-bottom-16') and contains(.,'Мінімальна кількість учасників аукціону')]//span[not(@class)]",
	"contractTerms": {
		"leaseTerms": {
			"years": u"//*[contains(@class,'margin-bottom-16') and contains(.,'Тривалість оренди')]//span[not(@class)]",
			"months": u"//*[contains(@class,'margin-bottom-16') and contains(.,'Тривалість оренди')]//span[not(@class)]",
		}
	},
	"value": {
		"amount": u"//h4[@class='font-20 success-color bold']",
	},
	"minimalStep": {
		"amount": u"//*[contains(@class,'margin-bottom-16') and contains(.,'Мінімальний крок аукціону')]//span[not(@class)]",
	},
	"guarantee": {
		"amount": u"//*[contains(@class,'margin-bottom-16') and contains(.,'Гарантійний внесок')]//span[not(@class)]",
	},
	"budgetSpent": {
		"amount": u"//*[contains(@class,'margin-bottom-16') and contains(.,'Вартість підготовки лоту до торгів')]//span[not(@class)]",
	},
	"registrationFee": {
		"amount": u"//*[contains(@class,'margin-bottom-16') and contains(.,'Оплата за участь')]//span[not(@class)]",
	},
	"bankAccount": {
		"bankName": u"(//*[@class='ivu-card-body' and contains(.,'Банківські реквізити')]//span[@data-qa])[1]",
		"accountIdentification": [
			{
				"description": "(//*[@class='ivu-card-body' and contains(.,'Банківські реквізити')]//*[@data-qa])[25]",
				"id": "(//*[@class='ivu-card-body' and contains(.,'Банківські реквізити')]//*[@data-qa])[27]",
			},
			{
				"id": "(//*[@class='ivu-card-body' and contains(.,'Банківські реквізити')]//*[@data-qa])[29]",
			},
			{
				"id": "(//*[@class='ivu-card-body' and contains(.,'Банківські реквізити')]//*[@data-qa])[31]",
			},
			{
				"id": "(//*[@class='ivu-card-body' and contains(.,'Банківські реквізити')]//*[@data-qa])[16]",
			},
			{
				"id": "(//*[@class='ivu-card-body' and contains(.,'Банківські реквізити')]//*[@data-qa])[18]",
			},
			{
				"id": "(//*[@class='ivu-card-body' and contains(.,'Банківські реквізити')]//*[@data-qa])[20]",
			},
			{
				"id": "(//*[@class='ivu-card-body' and contains(.,'Банківські реквізити')]//*[@data-qa])[7]",
			},
			{
				"id": "(//*[@class='ivu-card-body' and contains(.,'Банківські реквізити')]//*[@data-qa])[9]",
			},
			{
				"id": "(//*[@class='ivu-card-body' and contains(.,'Банківські реквізити')]//*[@data-qa])[11]",
			},
		],
	},
	"items": [
		{
			"description": "(//*[@class='margin-top-20 margin-bottom-20']//*[contains(@class,'ivu-col-span-sm-15')]//span)[1]",
			"additionalClassifications": [
				{
					"id": "(//*[@class='margin-top-20 margin-bottom-20']//*[contains(@class,'ivu-col-span-sm-15')]//span)[3]",
					"description": "(//*[@class='margin-top-20 margin-bottom-20']//*[contains(@class,'ivu-col-span-sm-15')]//span)[3]",
				},
				{
					"id": "(//*[@class='margin-top-20 margin-bottom-20']//*[contains(@class,'ivu-col-span-sm-15')]//span)[4]",
				}
			],
			"classification": {
				"id": "(//*[@class='margin-top-20 margin-bottom-20']//*[contains(@class,'ivu-col-span-sm-15')]//span)[2]",
				"description": "(//*[@class='margin-top-20 margin-bottom-20']//*[contains(@class,'ivu-col-span-sm-15')]//span)[2]",
			},
			"quantity": "(//*[@class='margin-top-20 margin-bottom-20']//*[contains(@class,'ivu-col-span-sm-15')]//span)[5]",
			"unit": {
				"name": "(//*[@class='margin-top-20 margin-bottom-20']//*[contains(@class,'ivu-col-span-sm-15')]//span)[5]",
			},
			"address": {
				"postalCode": "(//*[@class='margin-top-20 margin-bottom-20']//*[contains(@class,'ivu-col-span-sm-15')]//span)[6]",
				"region": "(//*[@class='margin-top-20 margin-bottom-20']//*[contains(@class,'ivu-col-span-sm-15')]//span)[6]",
				"locality": "(//*[@class='margin-top-20 margin-bottom-20']//*[contains(@class,'ivu-col-span-sm-15')]//span)[6]",
				"streetAddress": "(//*[@class='margin-top-20 margin-bottom-20']//*[contains(@class,'ivu-col-span-sm-15')]//span)[6]",
			},
		},
	],
}
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
        "description": u"",
      },
      "additionalClassifications": [
        {
          "scheme": "kvtspz",
          "id": "",
          "description": u"",
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