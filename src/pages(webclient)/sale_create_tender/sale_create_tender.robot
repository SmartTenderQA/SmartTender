*** Settings ***
Documentation    Suite description

*** Variables ***
${approve btn}			//*[@class="dxb" and contains(.,'Підтвердити перевірку')]

*** Keywords ***
Знайти переможця за назвою аукціона
	Click Element  //a[contains(@title,'Перечитати')]
	Дочекатись закінчення загрузки сторінки(webclient)
	Пошук об'єкта у webclient по полю  Загальна назва  ${data['title']}
	Click Element  //*[@class='gridbox' and contains(.,'Учасник')]//tr[not(contains(@class,'has-system-column')) and @class]
	Wait Until Page Contains Element  //a[@title='Кваліфікація']


Натиснути "Кваліфікація"
	Click Element  //a[@title='Кваліфікація']
	Wait Until Page Contains Element  ${approve btn}
	Wait Until Element Is Visible  //span[contains(text(),'Рішення кваліфікації')]


Натиснути "Підтвердити перевірку протоколу"
	Wait Until Element Is Visible  ${approve btn}
	Click Element  ${approve btn}
	Wait Until Element Is Visible  ${approve btn}/parent::*[contains(@class,'dxbDisabled')]


Додати протокол рішення
	Click Element  //*[contains(text(),'Перегляд...')]
	Дочекатись закінчення загрузки сторінки(webclient)
	${input file}  Set Variable  //*[@class='dxpc-content']//input[@type='file']
	${doc}  Створити та додати файл  ${input file}
	${md5}  get_checksum_md5  ${OUTPUTDIR}/${doc[1]}
	Wait Until Page Contains  ${doc[1]}
	Click Element  //*[contains(text(),'ОК')]
	Дочекатись закінчення загрузки сторінки(webclient)
	Click Element  //*[@class='dxr-lblText' and contains(text(),'Зберегти')]
	validation.Закрити валідаційне вікно (Так/Ні)  Ви впевнені у своєму рішенні?  Так
	Дочекатись закінчення загрузки сторінки(webclient)
	Set To Dictionary  ${docs_data}  key  bids
	Set To Dictionary  ${docs_data}  title  ${doc[1]}
	Set To Dictionary  ${docs_data}  documentType  Протокол рішення
	Set To Dictionary  ${docs_data}  hash  md5:${md5}
	${new docs}  Evaluate  ${docs_data}.copy()
	Append To List  ${data['documents']}  ${new docs}


Натиснути "Підтвердити оплату"
	Wait Until Keyword Succeeds  10s  2s  Click Element  //*[contains(@class,'dxb') and contains(.,'Підтвердити оплату')]
	Дочекатись закінчення загрузки сторінки(webclient)
	validation.Закрити валідаційне вікно (Так/Ні)  Ви впевнені у своєму рішенні?  Так


Натиснути "Прикріпити договір"
	Click Element  //*[@title='Прикріпити договір']
	Дочекатись закінчення загрузки сторінки(webclient)
	Wait Until Element Is Visible  //span[contains(text(),'Вкладення договірних документів')]


Заповнити поле "Номер договору"
	${first}  random_number  10000000  99999999
	${second}  random_number  10000  99999
	${number}  Set Variable  ABC${first}-${second}
	sale_keywords.Заповнити та перевірити текстове поле  //*[contains(text(),'Номер договору')]/following-sibling::table//input  ${number}
	Дочекатись закінчення загрузки сторінки(webclient)


Заповнити поле "Дата підписання"
	${date}  get_formated_time_with_delta  0  days  d
	sale_keywords.Заповнити та перевірити текстове поле  //*[contains(text(),'Дата підписання')]/following-sibling::table//input  ${date}


Прикріпити документ договору
	Click Element  //*[contains(text(),'Обзор...')]
	Дочекатись закінчення загрузки сторінки(webclient)
	${input file}  Set Variable  //*[@class='dxpc-content']//input[@type='file']
	${doc}  Створити та додати файл  ${input file}
	${md5}  get_checksum_md5  ${OUTPUTDIR}/${doc[1]}
	Page Should Contain  ${doc[1]}
	Click Element  //*[contains(text(),'ОК')]
	Дочекатись закінчення загрузки сторінки(webclient)
	Set To Dictionary  ${docs_data}  key  contracts
	Set To Dictionary  ${docs_data}  title  ${doc[1]}
	Set To Dictionary  ${docs_data}  documentType  Договір
	Set To Dictionary  ${docs_data}  hash  md5:${md5}
    ${new docs}  Evaluate  ${docs_data}.copy()
	Append To List  ${data['documents']}  ${new docs}


Зберегти договір
	Click Element  //*[contains(text(),'OK')]
	Дочекатись закінчення загрузки сторінки(webclient)
	Element Should Not Be Visible  //span[contains(text(),'Вкладення договірних документів')]


Натиснути "Підписати договір"
	Click Element  //*[contains(text(),'Підписати договір')]
	Дочекатись закінчення загрузки сторінки(webclient)
	validation.Закрити валідаційне вікно (Так/Ні)  Ви дійсно хочете підписати договір?  Так
	Дочекатись закінчення загрузки сторінки(webclient)
	validation.Закрити валідаційне вікно (Так/Ні)  Договір підписаний  ОК
