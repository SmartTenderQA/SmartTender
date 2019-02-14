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


Заповнити value.amount
	[Arguments]  ${text}
	${selector}  sale_keywords.Отримати локатор по назві поля  ['value']['amount']
	Wait Until Keyword Succeeds  30  3  sale_keywords.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити minimalStep.amount
	[Arguments]  ${text}
	${selector}  sale_keywords.Отримати локатор по назві поля  ['minimalStep']['amount']
	Wait Until Keyword Succeeds  30  3  cdb2_PropertyLease_page.Заповнити поле мінімальний крок  ${selector}  ${text}


Заповнити поле мінімальний крок
	[Arguments]  ${selector}  ${text}
	Scroll Page To Element XPATH  ${selector}
	Click Element  ${selector}
	Sleep  .5
	Run Keyword And Ignore Error  Clear input By JS  ${selector}
	Input Text  ${selector}  ${text}
	${got}  Get Element Attribute  ${selector}  value
	Click Element  //*[@data-name="MINSTEP_L"]
	Should Be Equal As Strings  ${got}  ${text}


Заповнити title
	[Arguments]  ${text}
	${selector}  sale_keywords.Отримати локатор по назві поля  ['title']
	Wait Until Keyword Succeeds  30  3  sale_keywords.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити lotIdentifier
	[Arguments]  ${text}
	${selector}  sale_keywords.Отримати локатор по назві поля  ['lotIdentifier']
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
	${classification}  Wait Until Keyword Succeeds  30  3  cdb1_dgfAssets_page.Вибрати та повернути випадкову класифікацію
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
	${locality}  ${region}  ${countryName}  Wait Until Keyword Succeeds  30  3  cdb1_dgfAssets_page.Вибрати та повернути випадкове місто
	[Return]  ${locality}  ${region}  ${countryName}


Заповнити guarantee.amount
	[Arguments]  ${text}
	${selector}  sale_keywords.Отримати локатор по назві поля  ['guarantee']['amount']
	Wait Until Keyword Succeeds  30  3  sale_keywords.Заповнити та перевірити текстове поле  ${selector}  ${text}


Очистити поле "Прийом пропозицій по"
    Clear input By JS  //*[contains(text(), 'Прийом пропозицій')]/following-sibling::table//input


Заповнити contractTerms.leaseTerms.leaseDuration
    [Arguments]  ${text}
    ${selector}  sale_keywords.Отримати локатор по назві поля  ['contractTerms']['leaseTerms']['leaseDuration']
    Wait Until Keyword Succeeds  30  3  sale_keywords.Заповнити та перевірити текстове поле  ${selector}  ${text}


Заповнити procuringEntity.contactPoint.name
	${name}  Wait Until Keyword Succeeds  30  3  cdb1_dgfAssets_page.Вибрати та повернути випадкову контактну особу
	[Return]  ${name}

###########################################################################
############################ WORK WITH FIELD ##############################
###########################################################################
Вибрати та повернути випадкове місто
	${input}  Set Variable  //*[@id='pcModalMode_PW-1']//span[contains(text(), 'Місто')]/following-sibling::*//input
	${selector}  Set Variable  //*[contains(text(), 'Місто')]/ancestor::*[contains(@class, 'dhxcombo_hdrtext')]/../following-sibling::*/*[@class='dhxcombo_option']
	Click Element  ${input}
	Sleep  .5
	Run Keyword And Ignore Error  Click Element  ${input}/../following-sibling::*
	Sleep  .5
	Wait Until Page Contains Element  ${selector}  15
	${count}  Get Element Count  ${selector}
	${number}  random_number  1  ${count}
	${locality}  Get Text  xpath=(((${selector})[${number}])//*[@class="dhxcombo_cell_text"])[1]
	${region}  Get Text  xpath=((${selector})[${number}]//*[@class="dhxcombo_cell_text"])[2]
	${countryName}  Get Text  xpath=((${selector})[${number}]//*[@class="dhxcombo_cell_text"])[3]
	Click Element  (${selector})[${number}]
	Sleep  .5
	${text}  Get Element Attribute  ${input}  value
	Should Not Be Empty  ${text}
	[Return]  ${locality}  ${region}  ${countryName}


Вибрати та повернути випадкову контактну особу
	${input}  Set Variable  //*[@id='pcModalMode_PW-1']//span[contains(text(), 'Контактна особа')]/ancestor::*[@class='dxpnlControl_DevEx']/following-sibling::div//*[@class='dhxcombo_input_container ']/input
	${selector}  Set Variable  //*[contains(text(), 'Прізвище')]/ancestor::*[contains(@class, 'dhxcombo_hdrtext')]/../following-sibling::*/*[@class='dhxcombo_option']
	Click Element  ${input}
	Sleep  .5
	Click Element  ${input}/../following-sibling::*
	Sleep  .5
	Wait Until Page Contains Element  ${selector}  15
	${count}  Get Element Count  ${selector}
	${number}  random_number  1  ${count}
	${name}  Get Text  xpath=(((${selector})[${number}])//*[@class="dhxcombo_cell_text"])[1]
	Click Element  (${selector})[${number}]
	Sleep  .5
	${text}  Get Element Attribute  ${input}  value
	Should Not Be Empty  ${text}
	[Return]  ${text}


Вибрати та повернути випадкову класифікацію
	${input}  Set Variable  (//*[@id='pcModalMode_PW-1']//span[contains(text(), 'Класифікація')]/following-sibling::div)[2]//input
	${selector}  Set Variable  //*[contains(text(), 'Код класифікації')]/ancestor::*[contains(@class, 'dhxcombo_hdrtext')]/../following-sibling::*/*[@class='dhxcombo_option']
	Click Element  ${input}
	Sleep  .5
	Run Keyword And Ignore Error  Click Element  ${input}/../following-sibling::*
	Sleep  .5
	Wait Until Page Contains Element  ${selector}  15
	${count}  Get Element Count  ${selector}
	${number}  random_number  1  ${count}
	${id}  Get Text  xpath=(((${selector})[${number}])//*[@class="dhxcombo_cell_text"])[1]
	${description}  Get Text  xpath=((${selector})[${number}]//*[@class="dhxcombo_cell_text"])[2]
	Click Element  (${selector})[${number}]
	Sleep  .5
	${text}  Get Element Attribute  ${input}  value
	Should Not Be Empty  ${text}
	[Return]  ${id}  ${description}