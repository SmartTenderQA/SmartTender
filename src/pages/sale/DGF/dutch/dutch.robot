*** Settings ***


*** Variables ***


*** Keywords ***
#########################################################region#########################################################
#                                                    Заповнити поля                                                    #
########################################################################################################################
Заповнити auctionPeriod.startDate
	[Arguments]  ${text}
	${selector}  sale_keywords.Отримати локатор по назві поля  ['auctionPeriod']['startDate']
	Wait Until Keyword Succeeds  30  3  sale_keywords.Заповнити та перевірити поле з датою  ${selector}  ${text}


Заповнити dgfDecisionID
	[Arguments]  ${text}
	${selector}  sale_keywords.Отримати локатор по назві поля  ['dgfDecisionID']
	Wait Until Keyword Succeeds  30  3  sale_keywords.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити dgfDecisionDate
	[Arguments]  ${text}
	${selector}  sale_keywords.Отримати локатор по назві поля  ['dgfDecisionDate']
	Wait Until Keyword Succeeds  30  3  sale_keywords.Заповнити та перевірити поле з датою  ${selector}  ${text}


Заповнити value.amount
	[Arguments]  ${text}
	${selector}  sale_keywords.Отримати локатор по назві поля  ['value']['amount']
	Wait Until Keyword Succeeds  30  3  sale_keywords.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити minimalStep.amount
	[Arguments]  ${text}
	${selector}  sale_keywords.Отримати локатор по назві поля  ['minimalStep']['amount']
	Wait Until Keyword Succeeds  30  3  sale_keywords.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити procuringEntity.contactPoint.name
	${name}  Wait Until Keyword Succeeds  30  3  dgfAssets.Вибрати та повернути випадкову контактну особу
	[Return]  ${name}


Заповнити title
	[Arguments]  ${text}
	${selector}  sale_keywords.Отримати локатор по назві поля  ['title']
	Wait Until Keyword Succeeds  30  3  sale_keywords.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити dgfID
	[Arguments]  ${text}
	${selector}  sale_keywords.Отримати локатор по назві поля  ['dgfID']
	Wait Until Keyword Succeeds  30  3  sale_keywords.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити description
	[Arguments]  ${text}
	${selector}  sale_keywords.Отримати локатор по назві поля  ['description']
	Wait Until Keyword Succeeds  30  3  sale_keywords.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити items.0.description
	[Arguments]  ${text}
	${selector}  sale_keywords.Отримати локатор по назві поля  ['items'][0]['description']
	Wait Until Keyword Succeeds  30  3  sale_keywords.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити items.0.quantity
	[Arguments]  ${text}
	${selector}  sale_keywords.Отримати локатор по назві поля  ['items'][0]['quantity']
	Wait Until Keyword Succeeds  30  3  sale_keywords.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити items.0.unit.name
	${input}  Set Variable  //*[@id='pcModalMode_PW-1']//span[contains(text(), 'Од. вим.')]/following-sibling::*//input
	${selector}  Set Variable  //*[contains(text(), 'ОВ. Найменування')]/ancestor::*[contains(@class, 'dhxcombo_hdrtext')]/../following-sibling::*/*[@class='dhxcombo_option']
	${name}  Wait Until Keyword Succeeds  30  3  Вибрати та повернути елемент у випадаючому списку  ${input}  ${selector}
	[Return]  ${name}


Заповнити items.0.classification
	${classification}  Wait Until Keyword Succeeds  30  3  dgfAssets.Вибрати та повернути випадкову класифікацію
	[Return]  ${classification}


Заповнити items.0.address.postalCode
	[Arguments]  ${text}
	${selector}  sale_keywords.Отримати локатор по назві поля  ['items'][0]['address']['postalCode']
	Wait Until Keyword Succeeds  30  3  sale_keywords.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити items.0.address.streetAddress
	[Arguments]  ${text}
	${selector}  sale_keywords.Отримати локатор по назві поля  ['items'][0]['address']['streetAddress']
	Wait Until Keyword Succeeds  30  3  sale_keywords.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити items.0.address.locality
	${locality}  ${region}  ${countryName}  Wait Until Keyword Succeeds  30  3  dgfAssets.Вибрати та повернути випадкове місто
	[Return]  ${locality}  ${region}  ${countryName}


Заповнити guarantee.amount
	[Arguments]  ${text}
	${selector}  sale_keywords.Отримати локатор по назві поля  ['guarantee']['amount']
	sale_keywords.Заповнити та перевірити текстове поле  ${selector}  ${text}
