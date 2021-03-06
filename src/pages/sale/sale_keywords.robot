*** Settings ***


*** Variables ***
${qualification docs btn}				//a[@class='ivu-btn ivu-btn-primary ivu-btn-circle font-18 action-block-btn']
${qualification docs unload btn}		//*[@class='ivu-card-body']//button[contains(@class,'ivu-btn-long')]
${notice message}						//*[@class='ivu-notice-desc']
${notice block}                         //*[@class="ivu-notice-notice-content"]


*** Keywords ***
########## common ###############################
Натиснути кнопку зберегти
	${save btn}  Set variable  //*[@data-qa='button-success']|//*[@data-qa='btn-success']
	elements.Дочекатися відображення елемента на сторінці  ${save btn}  10
    Scroll Page To Element XPATH  ${save btn}
    Click Element  ${save btn}
	elements.Дочекатися відображення елемента на сторінці  ${notice block}  30
    ${notice text}  Get Text  ${notice message}
	Should Contain Any  ${notice text}  Аукціон було успішно  Об'єкт приватизації було успішно  Інформаційне повідомлення було
	Дочекатись закінчення загрузки сторінки
	Wait Until Page Does Not Contain Element  ${notice block}


Натиснути кнопку опублікувати
	${publish btn}  Set Variable  //button[contains(.,'Опублікувати')]|//button[contains(.,'Передати на перевірку')]
	elements.Дочекатися відображення елемента на сторінці  ${publish btn}  10
	Scroll Page To Element XPATH  ${publish btn}
	Click Element  ${publish btn}
    elements.Дочекатися відображення елемента на сторінці  ${notice block}  30
    ${notice text}  Get Text  ${notice message}
	Should Contain Any  ${notice text}  Аукціон було успішно опубліковано  Об'єкт приватизації було успішно опубліковано  Інформаційне повідомлення було опубліковано  Інформаційне повідомлення було передано на перевірку, за умови успішного результату через деякий час будуть перенесені усі дані з об'єкту приватизації
	Wait Until Page Does Not Contain Element  ${notice block}


Отримати та зберегти tender_id
	Пошук об'єкта у webclient по полю  Загальна назва  ${data['title'].replace('[ТЕСТУВАННЯ] ','')}
	${tender_id}  Get Element Attribute  xpath=//a[@href and contains(text(),'UA-')]  text
	Set To Dictionary  ${data}  tender_id=${tender_id}


Отримати посилання в ЦБД
    ${cdb locator}  Set Variable  //*[contains(@class,'margin-bottom') and contains(.,'Посилання у ЦБД')]//a
    Wait Until Element Is Visible  ${cdb locator}  120
    ${cdb href}  Get Element Attribute  ${cdb locator}  href
    Set Global Variable  ${cdb href}  ${cdb href}


Отримати prozorro ID
    ${cdb locator}  Set Variable  //*[contains(@class,'margin-bottom-16') and contains(.,'Посилання') and contains(.,'ЦБД')]//a
    Wait Until Element Is Visible  ${cdb locator}  120
    ${cdb href}  Get Element Attribute  ${cdb locator}  href
    ${cdb href}  Поправити лінку для IP  ${cdb href}
    ${cdb id}  Evaluate  (re.findall(r'[a-z0-9]{32}','${cdb href}'))[0]  re
    Set To Dictionary  ${data}  id  ${cdb id}


Отримати локатор по назві поля
	[Arguments]  ${field}
	${selector}  Set Variable  ${edit_locators${field}}
	[Return]  ${selector}


Розгорнути детальну інформацію по всіх полях (за необхідністю)
	${read more btn}  Set Variable  //*[contains(@class,'second')]//a[not(@href) and contains(text(),'Детальніше')]
	${is contain}  Run Keyword And Return Status  Page Should Contain Element  {read more btn}
	Run Keyword If  ${is contain} == ${True}  Run Keywords
	...  Click Element  {read more btn}
	...  AND  Sleep  .5
	...  AND  sale_keywords.Розгорнути детальну інформацію по всіх полях (за необхідністю)


Натиснути "Кваліфікаційні документи"
	Click Element  xpath=${qualification docs btn}
	Дочекатись закінчення загрузки сторінки
	Page Should Contain Element  ${qualification docs unload btn}


Додати кваліфікаційний документ за типом
	[Arguments]  ${type}
	${input file}  Set Variable  //input[@type='file']
	${doc}  Створити та додати файл  ${input file}
	${md5}  get_checksum_md5  ${OUTPUTDIR}/${doc[1]}
	${row}  Set Variable  //*[@class='file ivu-row' and contains(.,'${doc[1]}')]
	sale_keywords.Вибрати тип документа  ${type}
	Run Keyword If  '${type}' == 'Протокол аукціону'
	...  Set To Dictionary  ${docs_data}  key  awards
	...  ELSE  Set To Dictionary  ${docs_data}  key  bids
	Set To Dictionary  ${docs_data}  title  ${doc[1]}
	Set To Dictionary  ${docs_data}  documentType  ${type}
	Set To Dictionary  ${docs_data}  hash  md5:${md5}
    ${new docs}  Evaluate  ${docs_data}.copy()
	Append To List  ${data['documents']}  ${new docs}
	Log  ${new docs}
	Log  ${data}


Вибрати тип документа
	[Arguments]  ${type}
	${file type locator}  Set Variable  (//*[@class='dropdown'])[last()]
	Scroll Page To Element XPATH  ${file type locator}
	Click Element  ${file type locator}
	${menu locator}  Set Variable  (//*[@class="dropdown-menu"])[last()]
	Wait Until Element Is Visible  ${menu locator}
	Click Element  ${menu locator}//*[contains(text(),'${type}')]
	Element Should Contain  ${file type locator}  ${type}


Завантажити кваліфікаційні документи
	Click Element  ${qualification docs unload btn}
	${notice btn}  Set Variable  //*[@class='ivu-modal-content']
	Wait Until Page Contains Element  ${notice btn}  30
	Wait Until Element Contains  ${notice btn}  Кваліфікаційні документи відправлені
	Click Element  //button[contains(.,'OK')]


#todo dodelat` pozzhe
#Замінити кваліфікаційний документ за назвою
#	[Arguments]  ${file name}
#	${row}  Set Variable  //*[@class='file ivu-row' and contains(.,'${file name}')]
#
#	${doc}  Створити та додати файл  ${row}//button[not(@data-toggle)]
#	# //button[not(@data-toggle)]


Розгорнути кваліфікаційні документи переможця
	${locator}  Set Variable  //i[contains(@class,'dropdown')]
	Click Element  ${locator}
	Sleep  1


########################################################################################################################
############################################ work with fields ##########################################################
########################################################################################################################
Вибрати та повернути елемент з випадаючого списку
    [Arguments]  ${selector}  ${text}=''
  	${items}  Set Variable  ${selector}//ul[@class='ivu-select-dropdown-list']//li
	Scroll Page To Element XPATH  ${selector}
    Click Element  ${selector}
    Sleep  .5
    Run Keyword If  "${text}" != "''"  Run Keywords
    ...  Run Keyword And Ignore Error  Input Text  ${selector}//input[@type='text']  ${text}
    ...  AND  Sleep  1.5
    Wait Until Element Is Visible  ${items}
    ${items count}  Get Element Count  ${items}
	${items number}  random_number  1  ${items count}
	${item name}  Get Text  (${items})[${items number}]
    Click Element  (${items})[${items number}]
    Sleep  .5
   	Should Not Be Empty  ${item name}
    [Return]  ${item name}


Розгорнути всі списки
	[Arguments]  ${modal locator}
	${closed li}  Set Variable  (${modal locator}//*[contains(@data-qa,'modal-tree')])[1]//li[contains(@class,'jstree-closed')]
	: FOR  ${i}  IN RANGE  99999
	\  ${closed li num}  Get Element Count  xpath=${closed li}
	\  Exit For Loop If    ${closed li num} == 0
    \  ${a}  Set Variable  ${closed li}/a
    \  Run Keyword And Ignore Error  Click Element  xpath=${a}
    \  Sleep  .5


Вибрати та повернути випадковий елемент з класифікації
    [Arguments]  ${selector}
	${modal locator}  Set Variable  //div${selector}
	${modal close locator}  Set Variable  ${modal locator}//*[@class='ivu-modal-close']
	${is opened}  Run Keyword And Return Status  Element Should Be Visible  ${modal close locator}
	Run Keyword If  ${is opened}  Run Keywords
	...  Click Element  ${modal close locator}  AND
	...  Sleep  .5
    Click Element  //a${selector}
	Wait Until Element Is Visible  ${modal locator}
	Sleep  1.5
	sale_keywords.Розгорнути всі списки  ${modal locator}
	${items}  Set Variable  ${modal locator}//li[contains(@class,'jstree-leaf')]/a
	${items count}  Get Element Count  xpath=${items}
	${random item}  random_number  1  ${items count}
	${item}  Set Variable  xpath=(${items})[${random item}]
	Click Element  ${item}
	${value}  Get Text  ${item}
	Sleep  .5
	Click Element  ${modal locator}//button
	Sleep  1
	[Return]  ${value}


Вибрати та повернути елемент з класифікації за назвою
    [Arguments]  ${selector}  ${text}
    Click Element  //a${selector}
    ${modal locator}  Set Variable  //div${selector}
	Wait Until Element Is Visible  ${modal locator}
	Sleep  .5
	${input}  Set Variable  ${modal locator}//input
	Input Text  ${input}  ${text}
	Sleep  1.5
	${item}  Set Variable  ${modal locator}//a[contains(text(),'${text}')]
	Click Element  ${item}
	${value}  Get Text  ${item}
	Sleep  .5
	Click Element  ${modal locator}//button
	Sleep  1
	[Return]  ${value}


Заповнити та перевірити поле з вартістю
	[Arguments]  ${selector}  ${text}
	Scroll Page To Element XPATH  ${selector}
	Click Element  ${selector}
	Sleep  .5
	Run Keyword And Ignore Error  Clear input By JS  ${selector}
	Input Text  ${selector}  ${text}
	${got}  Get Element Attribute  ${selector}  value
	${got}  Evaluate  '${got}'.replace(' ','')
	Press Key  ${selector}  \\13
	Should Be Equal  ${got}  ${text}


Заповнити та перевірити текстове поле
	[Arguments]  ${selector}  ${text}
	Scroll Page To Element XPATH  ${selector}
	Click Element  ${selector}
	Sleep  .5
	Run Keyword And Ignore Error  Clear input By JS  ${selector}
	Input Text  ${selector}  ${text}
	${got}  Get Element Attribute  ${selector}  value
	Press Key  ${selector}  \\13
	Should Be Equal As Strings  ${got}  ${text}


Заповнити та перевірити поле з датою
	[Arguments]  ${selector}  ${text}
	Scroll Page To Element XPATH  ${selector}
	Click Element  ${selector}
	Sleep  .5
	Run Keyword And Ignore Error  Clear input By JS  ${selector}
	Run Keyword If  '${site}' == 'prod'
	...  Input Text  ${selector}  ${text.replace('.','').replace(' ','').replace(':','')}
	Run Keyword If  '${site}' == 'test'
	...  Input Text  ${selector}  ${text}
	${got}  Get Element Attribute  ${selector}  value
	Press Key  ${selector}  \\13
	Should Be Equal As Strings  ${got}  ${text}
########################################################################################################################
############################################ /work with fields #########################################################
########################################################################################################################