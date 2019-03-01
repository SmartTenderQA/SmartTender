*** Settings ***
Documentation
Metadata  Команда запуска
...  robot --consolecolors on -L TRACE:INFO -d test_output -v EDS:True -e get_tender -v hub:none suites/qulification_files/suite.robot

Resource   ../../src/src.robot

Suite Setup     Precondition
Suite Teardown  Close All Browsers
Test Setup      Stop The Whole Test Execution If Previous Test Failed
Test Teardown   Run Keyword If Test Failed  Run Keywords
...                                         Log Location  AND
...                                         Capture Element Screenshot  //body  AND
...                                         actions.Зберегти словник у файл  ${data}  data


*** Test Cases ***
Підготувати браузер (змінена папка для загрузок)
    Close Browser
    Create Directory  ${OUTPUTDIR}/downloads/
    Відкрити браузер Chrome з вказаною папкою для завантаження файлів  ${OUTPUTDIR}/downloads/


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


Подати заявку на участь в тендері першим учасником
    [Tags]  proposal  privat
    Завантажити сесію для  ${provider1}
    Go to  ${data['tender_href']}
    procurement_tender_detail.Дочекатися статусу тендера  Прийом пропозицій
    Sleep  3m
    Перевірити кнопку подачі пропозиції
	make_proposal.Заповнити поле з ціною  1  1
    ${file name}  ${hash}  actions.Додати doc файл
    #  Позначаемо файл як конфіденційний та зберігаємо інфу про нього
    ${private reason}  make_proposal.Позначити файл як конфіденційний  ${file name}
    Set Global Variable  ${private reason}
    Зберегти дані файлу у словник docs_data  bids  ${file name}  ${hash}
    #################################################################
	Run Keyword And Ignore Error  Підтвердити відповідність
	make_proposal.Подати пропозицію
	EDS.Підписати ЕЦП
    Go Back
    Додати додатковий документ до пропозиції


Подати заявку на участь в тендері другим учасником
    [Tags]  proposal
    Завантажити сесію для  ${provider2}
    Go to  ${data['tender_href']}
    Перевірити кнопку подачі пропозиції
	Заповнити поле з ціною  1  1
	actions.Додати doc файл
	Run Keyword And Ignore Error  Підтвердити відповідність
	Подати пропозицію
	EDS.Підписати ЕЦП
    Go Back
    Додати додатковий документ до пропозиції


Дочекатись початку періоду перкваліфікації
    [Tags]  sync  pre-qualification
    procurement_page_keywords.Дочекатись початку періоду перкваліфікації
    procurement_page_keywords.Дочекатися відображення блоку прекваліфікація на сторінці  3m


Перевірити наявність конфіденційного документу на сторінці та в ЦБД
    [Tags]  privat
    Отримати дані з cdb та зберегти їх у файл
    procurement_tender_detail.Розгорнути всі експандери
    procurement_tender_detail.Порівняти створений документ з документом в ЦБД procurement  ${data['qualification_documents'][0]}
    procurement_tender_detail.Порівняти відображений документ з документом в ЦБД procurement  ${data['qualification_documents'][0]}
    #  Перевірити неможливість перегляду конфіденційного документу
    Run Keyword And Expect Error  *not visible*
    ...  procurement_tender_detail.Скачати файл на сторінці  ${data['qualification_documents'][0]['title']}
    #  Порівняти причину конфіденційності в ЦБД
    Should Be Equal  ${private reason}  ${cdb['bids'][0]['documents'][0]['confidentialityRationale']}


Відкрити браузер під роллю організатора та знайти тендер
    Завантажити сесію для  ${tender_owner}
	desktop.Перейти у розділ (webclient)  Публічні закупівлі (тестові)
    main_page.Знайти тендер організатором по title  ${data['title']}


Підтвердити прекваліфікацію для доступу до аукціону організатором
    [Tags]  pre-qualification
    qualification.Провести прекваліфікацію учасників


Дочекатися статусу тендера "Кваліфікація"
    [Tags]  sync  qualification
	Завантажити сесію для  ${provider1}
    Go to  ${data['tender_href']}
	procurement_tender_detail.Дочекатися статусу тендера  Кваліфікація


Перевірити відображення причини конфіденційності документу
    #procurement_tender_detail.Розгорнути всі експандери
    No Operation


Перевірити наявність ЕЦП finance document в поданих пропозиціях
    [Tags]  EDS  validation
    Go to  ${data['tender_href']}
    Отримати дані з cdb та зберегти їх у файл
    :FOR  ${i}  IN  1  2
    \  ${hash}  Wait Until Keyword Succeeds  60  1  Скачати файл з іменем та індексом для користувача  ${i}  sign.p7s  2
    \  Зберегти дані файлу у словник docs_data  bids  sign.p7s  ${hash}
    \  Звірити підпис ЕЦП (фінансовий документ) в ЦБД та на сторінці procurement  ${data['qualification_documents'][${i}]}  2


Відхилити організатором пропозицію першого учасника
    [Tags]  qualification  EDS
    Завантажити сесію для  ${tender_owner}
	desktop.Перейти у розділ (webclient)  Публічні закупівлі (тестові)
    main_page.Знайти тендер організатором по title  ${data['title']}
    ${negative result file name}  ${hash}  qualification.Відхилити пропозицію учасника  1  ${EDS}  ${cdb['procurementMethodType']}
    Зберегти дані файлу у словник docs_data  awards  ${negative result file name}  ${hash}


Завантажити другим учасником кваліфікаційний документ
    [Tags]  qualification-docs  EDS
    Завантажити сесію для  ${provider2}
    Go to  ${data['tender_href']}
    ${provider file name}  ${hash}  procurement_tender_detail.Додати кваліфікаційний документ  ${EDS}
    Зберегти дані файлу у словник docs_data  bids  ${provider file name}  ${hash}


Завантажити другим учасником додатковий кваліфікаційний документ
    [Tags]  qualification-docs  EDS
    ${provider file name 2}  ${hash}  procurement_tender_detail.Додати кваліфікаційний документ  ${EDS}
    Зберегти дані файлу у словник docs_data  bids  ${provider file name 2}  ${hash}


#TODO  Замінити другим учасником останній кваліфікаційний документ


Визнати переможцем другого учасника
    [Tags]  qualification  EDS
    Завантажити сесію для  ${tender_owner}
	desktop.Перейти у розділ (webclient)  Публічні закупівлі (тестові)
    main_page.Знайти тендер організатором по title  ${data['title']}
    ${positive result file name}  ${hash}  qualification.Визначити учасника переможцем  2  ${EDS}  ${cdb['procurementMethodType']}
    Зберегти дані файлу у словник docs_data  awards  ${positive result file name}  ${hash}


Прикріпити договір до переможця
    [Tags]  contract
    qualification_keywords.Вибрати переможця за номером  2
    ${dogovir name}  ${hash}  qualification.Додати договір до переможця
    Зберегти дані файлу у словник docs_data  contracts  ${dogovir name}  ${hash}


Дочекатися статусу тендера "Пропозиції розглянуті"
    [Tags]  sync
	Завантажити сесію для  ${provider1}
    Go to  ${data['tender_href']}
	procurement_tender_detail.Дочекатися статусу тендера  Пропозиції розглянуті


Додати переможцем кваліфікаційний документ на стадії "Пропозиції розглянуті"
     [Tags]  qualification-docs  EDS
    Завантажити сесію для  ${provider2}
    Go to  ${data['tender_href']}
    ${provider file name 3}  ${hash}  procurement_tender_detail.Додати кваліфікаційний документ  ${EDS}
    Зберегти дані файлу у словник docs_data  bids  ${provider file name 3}  ${hash}


Підписати організатором договір з переможцем
    [Tags]  contract
    Завантажити сесію для  ${tender_owner}
	desktop.Перейти у розділ (webclient)  Публічні закупівлі (тестові)
    main_page.Знайти тендер організатором по title  ${data['title']}
    Sleep  9m
    qualification.Підписати договір з переможцем  2


Переконатись що статус закупівлі "Завершено"
    [Tags]  sync
    Завантажити сесію для  ${provider1}
    Go to  ${data['tender_href']}
    procurement_tender_detail.Дочекатися статусу тендера  Завершено


Підготуватися до перевірки відображення документів на сторінці
    Go to  ${data['tender_href']}
    actions.Зберегти словник у файл  ${data}  data
    Отримати дані з cdb та зберегти їх у файл


Перевірити публікацію кваліфікаційних файлів в ЦБД
    [Tags]  validation
    [Template]  procurement_tender_detail.Порівняти створений документ з документом в ЦБД procurement
    ${data['qualification_documents'][3]}
	${data['qualification_documents'][4]}
	${data['qualification_documents'][5]}
	${data['qualification_documents'][6]}
    ${data['qualification_documents'][7]}
    ${data['qualification_documents'][8]}


Перевірити публікацію кваліфікаційних файлів на сторінці користувачами
    [Tags]  validation
    [Setup]  Run Keywords
    ...  Go to  ${data['tender_href']}  AND
    ...  procurement_tender_detail.Розгорнути всі експандери
    [Template]  procurement_tender_detail.Порівняти відображений документ з документом в ЦБД procurement
    ${data['qualification_documents'][3]}
	${data['qualification_documents'][4]}
	${data['qualification_documents'][5]}
	${data['qualification_documents'][6]}
    ${data['qualification_documents'][7]}
    ${data['qualification_documents'][8]}




*** Keywords ***
Precondition
    Set Global Variable         ${tender_owner}   PPR_OR
    Set Global Variable         ${provider1}      user1
    Set Global Variable         ${provider2}      user2
    Set Global Variable         ${viewer}         test_viewer
    Додати першого користувача  ${tender_owner}
    Додати користувача          ${provider1}
    Додати користувача          ${provider2}
    Додати користувача          ${viewer}


Відкрити браузер Chrome з вказаною папкою для завантаження файлів
    [Arguments]  ${downloadDir}
    ${chromeOptions} =    Evaluate    sys.modules['selenium.webdriver'].ChromeOptions()    sys, selenium.webdriver
    ${prefs} =    Create Dictionary    download.default_directory=${downloadDir}
    Call Method    ${chromeOptions}    add_experimental_option    prefs    ${prefs}
    Call Method    ${chromeOptions}    add_argument    --window-size\=1280,1024
    Call Method    ${chromeOptions}    add_argument    --disable-gpu
    ${browser started}  Run Keyword And Return Status
    ...  Create Webdriver  Chrome  chrome_options=${chromeOptions}
    Should Be True  ${browser started}


Отримати дані з cdb та зберегти їх у файл
    ${id}  procurement_tender_detail.Отритами дані зі сторінки  ['id']
    ${cdb}  Отримати дані тендеру з cdb по id  ${id}
    Set Global Variable  ${cdb}
    actions.Зберегти словник у файл  ${cdb}  cdb


Додати додатковий документ до пропозиції
    Перевірити кнопку подачі пропозиції
    actions.Додати doc файл
    make_proposal.Подати пропозицію
	EDS.Підписати ЕЦП
    Go Back


Зберегти дані файлу у словник docs_data
    [Arguments]  ${key}  ${file name}  ${hash}
    Set To Dictionary  ${docs_data}  key  ${key}
    Set To Dictionary  ${docs_data}  title  ${file name}
    Set To Dictionary  ${docs_data}  hash  md5:${hash}
    ${new doc}  Evaluate  ${docs_data}.copy()
	Append To List  ${data['qualification_documents']}  ${new doc}


Скачати файл з іменем та індексом для користувача
    [Arguments]  ${user index}  ${name}  ${index}
    ${selector}  Set Variable  (//*[@data-qa="file-name"][text()="${name}"])[${index}]
    ${download locator}  Set Variable  ${selector}/ancestor::div[@class="ivu-poptip"]//*[@data-qa="file-download"]
    procurement_tender_detail.Розгорнути всі експандери учасника  ${user index}
    elements.Дочекатися відображення елемента на сторінці  ${selector}
    Mouse Over  ${selector}
    Wait Until Element Is Visible  ${download locator}
    Click Element                  ${download locator}
    ${status}  Run Keyword And Return Status  Element Should Be Visible  ${selector}
    Run Keyword If  '${status}' == 'False'  Run Keywords
    ...  Go Back      AND
    ...  Reload Page
    ${md5}   Wait Until Keyword Succeeds  10  .5  get_checksum_md5  ${OUTPUTDIR}/downloads/sign.p7s
    Empty Directory   ${OUTPUTDIR}/downloads/
    procurement_tender_detail.Згорнути всі експандери учасника  ${user index}
    [Return]  ${md5}


Звірити підпис ЕЦП (фінансовий документ) в ЦБД та на сторінці procurement
	[Arguments]  ${doc}  ${index}
	${cdb_doc}  get_cdb_fin_doc  ${doc}  ${cdb}
	${view doc block}  Set Variable  (//*[@style and @class='ivu-row' and contains(.,'${doc['title']}')])[${index}]
	Scroll Page To Element XPATH    ${view doc block}
	${view title}         Get Text  ${view doc block}${docs_view['title']}
	Should Be Equal  ${view title}  ${cdb_doc['title']}  Oops! Помилка з title
    ${view dateModified}  Get Text  ${view doc block}${docs_view['dateModified']}
	Should Be Equal  ${view dateModified}  ${cdb_doc['dateModified']}  Oops! Помилка з dateModified


