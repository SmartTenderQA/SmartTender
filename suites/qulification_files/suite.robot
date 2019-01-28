*** Settings ***
Documentation
Metadata  Команда запуска
...  robot --consolecolors on -L TRACE:INFO -d test_output -v EDS:True -e get_tender -v hub:none suites/qulification_files/suite.robot

Resource   ../../src/src.robot
Suite Setup     Precondition
Suite Teardown  Close All Browsers
Test Teardown  Run Keyword If Test Failed  Run Keywords
...                                        Log Location  AND
...                                        Capture Page Screenshot


*** Test Cases ***
Створити тендер
	[Tags]  create_tender
	Завантажити сесію для  ${tender_owner}
	test_open_eu.Створити тендер
    test_open_eu.Отримати дані тендера та зберегти їх у файл


Отримати тип процедури з cdb
    [Tags]  create_tender
    Go to  ${data['tender_href']}
    Отримати дані з cdb та зберегти їх у файл
    Log  ${cdb['procurementMethodType']}


If skipped create tender
	[Tags]  get_tender
	${json}  Get File  ${OUTPUTDIR}/artifact_data.json
	${data}  conver json to dict  ${json}
	Set Global Variable  ${data}


Подати заявку на участь в тендері двома учасниками
	Прийняти участь у тендері учасником  ${provider1}
	Додати додатковий документ до пропозиції
	Прийняти участь у тендері учасником  ${provider2}
	Додати додатковий документ до пропозиції


Дочекатись початку періоду перкваліфікації
    [Setup]  Stop The Whole Test Execution If Previous Test Failed
    procurement_page_keywords.Дочекатись початку періоду перкваліфікації


Відкрити браузер під роллю організатора та знайти тендер
    Завантажити сесію для  ${tender_owner}
	desktop.Перейти у розділ (webclient)  Публічні закупівлі (тестові)
    main_page.Знайти тендер організатором по title  ${data['title']}


Підтвердити прекваліфікацію для доступу до аукціону організатором
    [Setup]  Stop The Whole Test Execution If Previous Test Failed
    qualification.Провести прекваліфікацію учасників


Дочекатися статусу тендера "Кваліфікація"
    [Setup]  Stop The Whole Test Execution If Previous Test Failed
	Завантажити сесію для  ${provider1}
    Go to  ${data['tender_href']}
	procurement_tender_detail.Дочекатися статусу тендера  Кваліфікація


Перевірити наявність ЕЦП finance document в поданих пропозиціях
    Go to  ${data['tender_href']}
    Отримати дані з cdb та зберегти їх у файл
    :FOR  ${i}  IN  1  2
    \  procurement_tender_detail.Розгорнути всі експандери учасника  ${i}
    \  ${hash}  Скачати файл з іменем та індексом  sign.p7s  2
    \  Зберегти дані файлу у словник docs_data  bids  sign.p7s  ${hash}
    \  Звірити підпис ЕЦП (фінансовий документ) в ЦБД та на сторінці procurement  ${data['qulification_documents'][${i}-1]}  2
    \  procurement_tender_detail.Згорнути всі експандери учасника  ${i}


Відхилити організатором пропозицію першого учасника
    Завантажити сесію для  ${tender_owner}
	desktop.Перейти у розділ (webclient)  Публічні закупівлі (тестові)
    main_page.Знайти тендер організатором по title  ${data['title']}
    ${negative result file name}  ${hash}  qualification.Відхилити пропозицію учасника  1  ${EDS}  ${cdb['procurementMethodType']}
    Зберегти дані файлу у словник docs_data  awards  ${negative result file name}  ${hash}


Завантажити другим учасником кваліфікаційний документ
    Завантажити сесію для  ${provider2}
    Go to  ${data['tender_href']}
    ${provider file name}  ${hash}  procurement_tender_detail.Додати кваліфікаційний документ  ${EDS}
    Зберегти дані файлу у словник docs_data  bids  ${provider file name}  ${hash}


Завантажити другим учасником додатковий кваліфікаційний документ
    ${provider file name 2}  ${hash}  procurement_tender_detail.Додати кваліфікаційний документ  ${EDS}
    Зберегти дані файлу у словник docs_data  bids  ${provider file name 2}  ${hash}


#TODO  Замінити другим учасником останній кваліфікаційний документ


Визнати переможцем другого учасника
    Завантажити сесію для  ${tender_owner}
	desktop.Перейти у розділ (webclient)  Публічні закупівлі (тестові)
    main_page.Знайти тендер організатором по title  ${data['title']}
    ${positive result file name}  ${hash}  qualification.Визначити учасника переможцем  2  ${EDS}  ${cdb['procurementMethodType']}
    Зберегти дані файлу у словник docs_data  awards  ${positive result file name}  ${hash}


Прикріпити договір до переможця
    qualification_keywords.Вибрати переможця за номером  2
    ${dogovir name}  ${hash}  qualification.Додати договір до переможця
    Зберегти дані файлу у словник docs_data  contracts  ${dogovir name}  ${hash}


Підготуватися до перевірки відображення документів на сторінці
    Go to  ${data['tender_href']}
    actions.Зберегти словник у файл  ${data}  data
    Отримати дані з cdb та зберегти їх у файл


Перевірити публікацію кваліфікаційних файлів в ЦБД
    [Template]  procurement_tender_detail.Порівняти створений документ з документом в ЦБД procurement
    ${data['qulification_documents'][2]}
	${data['qulification_documents'][3]}
	${data['qulification_documents'][4]}
	${data['qulification_documents'][5]}
    ${data['qulification_documents'][6]}


Перевірити публікацію кваліфікаційних файлів на сторінці користувачами
    [Setup]  Run Keywords
    ...  Go to  ${data['tender_href']}  AND
    ...  procurement_tender_detail.Розгорнути всі експандери
    [Template]  procurement_tender_detail.Порівняти відображений документ з документом в ЦБД procurement
    ${data['qulification_documents'][2]}
	${data['qulification_documents'][3]}
	${data['qulification_documents'][4]}
	${data['qulification_documents'][5]}
    ${data['qulification_documents'][6]}




*** Keywords ***
Precondition
    Set Global Variable         ${tender_owner}   PPR_OR
    Set Global Variable         ${provider1}      user1
    Set Global Variable         ${provider2}      user2
    Set Global Variable         ${viewer}         test_viewer
    Додати першого користувача  ${tender_owner}
    debug
    Додати користувача          ${provider1}
    Додати користувача          ${provider2}
    Додати користувача          ${viewer}
    Підготувати браузер


Підготувати браузер
    Close Browser
    Create Directory  ${OUTPUTDIR}/downloads/
    Відкрити браузер Chrome з вказаною папкою для завантаження файлів  ${OUTPUTDIR}/downloads/


Отримати дані з cdb та зберегти їх у файл
    ${id}  procurement_tender_detail.Отритами дані зі сторінки  ['id']
    ${cdb}  Отримати дані тендеру з cdb по id  ${id}
    Set Global Variable  ${cdb}
    actions.Зберегти словник у файл  ${cdb}  cdb


Прийняти участь у тендері учасником
    [Arguments]  ${username}
    Завантажити сесію для  ${username}
    Go to  ${data['tender_href']}
    procurement_tender_detail.Дочекатися статусу тендера  Прийом пропозицій
    Run Keyword If  '${username}' == '${provider1}'  Sleep  3m
    Подати пропозицію учасником


Подати пропозицію учасником
	Перевірити кнопку подачі пропозиції
	Заповнити поле з ціною  1  1
    actions.Додати doc файл
	Run Keyword And Ignore Error  Підтвердити відповідність
	Подати пропозицію
	EDS.Підписати ЕЦП
    Go Back


Додати додатковий документ до пропозиції
    Перевірити кнопку подачі пропозиції
    actions.Додати doc файл
    Подати пропозицію
	EDS.Підписати ЕЦП
    Go Back


Зберегти дані файлу у словник docs_data
    [Arguments]  ${key}  ${file name}  ${hash}
    Set To Dictionary  ${docs_data}  key  ${key}
    Set To Dictionary  ${docs_data}  title  ${file name}
    Set To Dictionary  ${docs_data}  hash  md5:${hash}
    ${new doc}  Evaluate  ${docs_data}.copy()
	Append To List  ${data['qulification_documents']}  ${new doc}


Скачати файл з іменем та індексом
    [Arguments]  ${name}  ${index}
    ${selector}  Set Variable  (//*[@data-qa="file-name"][text()="${name}"])[${index}]
    ${download locator}  Set Variable  ${selector}/ancestor::div[@class="ivu-poptip"]//*[@data-qa="file-download"]
    Mouse Over  ${selector}
    Wait Until Element Is Visible  ${download locator}
    Click Element                  ${download locator}
    Sleep  3
    ${md5}   get_checksum_md5  ${OUTPUTDIR}/downloads/sign.p7s
    Empty Directory   ${OUTPUTDIR}/downloads/
    [Return]  ${md5}


Відкрити браузер Chrome з вказаною папкою для завантаження файлів
    [Arguments]  ${downloadDir}
    ${chromeOptions} =    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    ${prefs} =    Create Dictionary    download.default_directory=${downloadDir}
    Call Method    ${chromeOptions}    add_experimental_option    prefs    ${prefs}
    Call Method    ${chromeOptions}    add_argument    --window-size\=1440,900
    #Call Method    ${chromeOptions}    add_argument    --disable-gpu
    ${webdriverCreated}  Run Keyword And Return Status  Create Webdriver  Chrome  chrome_options=${chromeOptions}
    Should Be True  ${webdriverCreated}


Звірити підпис ЕЦП (фінансовий документ) в ЦБД та на сторінці procurement
	[Arguments]  ${doc}  ${index}
	${cdb_doc}  get_cdb_fin_doc  ${doc}  ${cdb}
	${view doc block}  Set Variable  (//*[@style and @class='ivu-row' and contains(.,'${doc['title']}')])[${index}]
	Scroll Page To Element XPATH    ${view doc block}
	${view title}         Get Text  ${view doc block}${docs_view['title']}
	Should Be Equal  ${view title}  ${cdb_doc['title']}  Oops! Помилка з title
    ${view dateModified}  Get Text  ${view doc block}${docs_view['dateModified']}
	Should Be Equal  ${view dateModified}  ${cdb_doc['dateModified']}  Oops! Помилка з dateModified
