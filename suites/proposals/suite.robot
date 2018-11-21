*** Settings ***
Resource  ../../src/src.robot
Suite Setup  Start in grid  ${user}
Suite Teardown  Postcondition
Test Teardown  Run Keywords
...  Log Location
...  AND  Run Keyword If Test Failed  Capture Page Screenshot


*** Variables ***
${error}                            //*[@class='ivu-notice-notice ivu-notice-notice-closable ivu-notice-notice-with-desc']
${amount}                           ${block}[2]//div[@class='amount lead'][1]
${proposal}                         http://test.smarttender.biz/bid/edit
${useful indicators open}           //span[@class='ivu-select-selected-value']
${useful indicators list}           //div[@class='ivu-select-dropdown']/ul[2]/li
${button add file}                  //input[@type="file"][1]
${choice file button}               //button[@data-toggle="dropdown"]
${file button path}                 //div[@class="file-container"]/div
${choice file list}                 //div[@class="dropdown open"]//li
${sub field}                        //*[@id="lotSubcontracting0"]/textarea[1]
${EDS}                              ${block}[1]//div[@class="ivu-row"]//button
${EDS close}                        //*[@class="modal-dialog "]//button
${delete file}                      //div[@class="file-container"]/div[last()]/div/div[2]
${delete file confirm}              /div/div[2]//button[2]
${switch}                           //*[@class="ivu-switch" or @class="ivu-switch-inner"]
${switch field}                     //input[@placeholder]
${wait}                             60
${no tender}                        False


*** Test Cases ***
Знайти необхідний тендер
	Відкрити сторінку тестових торгів
	${ua_tender_type}  convert_tender_type  ${tender_type}
	Відфільтрувати по формі торгів  ${ua_tender_type}
	Відфільтрувати по статусу торгів  Прийом пропозицій
	${date}  smart_get_time  1  d
	Відфільтрувати по даті кінця прийому пропозиції від  ${date}
	Виконати пошук тендера для подачі пропозиції
	Перейти по результату пошуку  ${first found element}
	Додаткова перевірка на тестові торги для продуктива
	Перевірити кнопку подачі пропозиції
	Скасувати пропозицію за необхідністю
	${lots amount}  Порахувати Кількість Лотів
	Розгорнути лот  1


Перевірити неможливість подати пропозіцію без заповнення жодного поля
	Завершити тест якщо не знайдено тендер
	Перевірити неможливість подати пропозицію


Зповнити необхідні поля
    Завершити тест якщо не знайдено тендер
	Заповнити поле з ціною для першого лоту
	Підтвердити відповідність за наявністю
	Створити та додати файл до тендеру в цілому(тільки для open_trade_eng)


Подати пропозицію з мінімальною кількістю заповнених полів
	Завершити тест якщо не знайдено тендер
	Подати пропозицію


Підписати ЕЦП
	[Tags]  EDS
    Завершити тест якщо не знайдено тендер
    Підписати ЕЦП


Внести зміни у пропозицію
	Завершити тест якщо не знайдено тендер
	Розгорнути усі лоти
	Змінити цінову пропозицію(по кожному лоту окремо)
	Завантажити файли на весь тендер
	Видалити останній файл до тендеру
	Змінити тип файлу для кожного лоту
	Вибрати всі доступні типи файлів
	Визначити випадковий файл як конфіденційний
	Зазначивши причину конфіденційності
	Зазначити інформацію про субпідрядника(на всі лоти)
	Вибрати нецінові показники(на тендер в цілому та всі лоти)


Подати змінену цінову пропозицію
    Завершити тест якщо не знайдено тендер
    Подати пропозицію


Накласти ЕЦП на виправлену пропозицію
	[Tags]  EDS
	Завершити тест якщо не знайдено тендер
	Підписати ЕЦП


Скасувати пропозицію на процедуру/лот
    Завершити тест якщо не знайдено тендер
    Скасувати пропозицію


Перевірити неможливість подати пропозицію
    Завершити тест якщо не знайдено тендер
    Перевірити неможливість подати пропозицію


Перевірити неможливість накласти ЕЦП
	[Tags]  EDS
    Завершити тест якщо не знайдено тендер
    Run Keyword And Expect Error  *  Підписати ЕЦП


*** Keywords ***
Postcondition
	Close All Browsers


Заповнити поле з ціною для першого лоту
  Run depending on the dict  Amount  Заповнити поле з ціною  1  1
  Run Keyword If  "${tender_type}" == "ESCO"  Fill ESCO  1  60


Підтвердити відповідність за наявністю
	Run depending on the dict  Conformity  Підтвердити відповідність


Створити та додати файл до тендеру в цілому(тільки для open_trade_eng)
	Run Keyword If  "open_trade_eng" == "${tender_type}"  Створити та додати PDF файл  0


Змінити цінову пропозицію(по кожному лоту окремо)
  :FOR  ${i}  IN RANGE  1  ${lots amount}+1
  \  Run depending on the dict  Amount  Заповнити поле з ціною  ${i}  0.9
  \  Run Keyword If  "${tender_type}" == "ESCO"  Fill ESCO  1


Видалити останній файл до тендеру
	Delete file  1


Змінити тип файлу для кожного лоту
    Run Keyword If  "${blocks amount}" != "3"
    ...  Run depending on the dict  Document type
    ...  Змінити тип файлу для кожного лоту продовження


Змінити тип файлу для кожного лоту продовження
    :FOR  ${INDEX}  IN RANGE  2  ${blocks amount}
    \  Обрати тип файлу  ${INDEX}  last()  last()
    \  sleep  .5


Визначити випадковий файл як конфіденційний
	Run depending on the dict  Confidentiality  Визначити випадковий файл як конфіденційний продовження


Визначити випадковий файл як конфіденційний продовження
	${count}  Get Element Count  //*[@class="ivu-card ivu-card-bordered"][1]//*[@class="ivu-switch" or @class="ivu-switch-inner"]
	${n}  random_number  2  ${count}
	Confidentiality  1  ${n}


Зазначивши причину конфіденційності
	Run depending on the dict  Confidentiality  File description  1


Зазначити інформацію про субпідрядника(на всі лоти)
	Run depending on the dict  Sub information  Add info about sub LOOP


Вибрати нецінові показники(на тендер в цілому та всі лоти)
	Отримати всі нецінові показники
	Внести зміни до нецінових показників до тендеру та лотів




###    ESCO    ###
Fill ESCO
    [Arguments]  ${number_of_lot}  ${percent}=95
    ${number_of_lot}  Evaluate  ${number_of_lot}+1
    input text  xpath=(${block}[${number_of_lot}]//input)[1]  1
    input text  xpath=(${block}[${number_of_lot}]//input)[2]  0
    input text  xpath=(${block}[${number_of_lot}]//input)[3]  ${percent}
    input text  xpath=(${block}[${number_of_lot}]//input)[6]  100


###    Useful indicators    ###
Вибрати випадковий неціновий показник
    [Documentation]  takes block number and list number
    [Arguments]  ${block number}  ${list number}
	Click Element  (${block}[${block number}]${useful indicators open})[${list number}]
    Wait Until Element Is Visible  ${block}[${block number}]//*[contains(@class, 'visible')]${useful indicators list}  10
    ${count}  Get Element Count  ${block}[${block number}]//*[contains(@class, 'visible')]${useful indicators list}
    ${n}  random_number  1  ${count}
    Click Element  ${block}[${block number}]//*[contains(@class, 'visible')]${useful indicators list}[${n}]
    Sleep  2


Отримати всі нецінові показники
	${list of useful indicators}  Create List
	Set Global Variable  ${list of useful indicators}
	:FOR  ${block number}  IN RANGE  1  ${blocks amount}
	\  ${n}  Get Element Count	${block}[${block number}]${useful indicators open}
	\  Append To List  ${list of useful indicators}  ${n}
	Log  ${list of useful indicators}


Внести зміни до нецінових показників до тендеру та лотів
	Set Global Variable  ${block useful indicator}  1
	:FOR  ${i}  IN  @{list of useful indicators}
	\	Внести зміни до нецінових показників  ${i}


Внести зміни до нецінових показників
	[Arguments]  ${i}
	:FOR  ${j}  IN RANGE  1  ${i}+1
	\  Вибрати випадковий неціновий показник  ${block useful indicator}  ${j}
	${block useful indicator}  Evaluate  ${block useful indicator}+1



###    Add File    ###
Delete file
    [Documentation]  deleta last file
    [Arguments]  ${block number}
    wait until page contains element  ${block}[${block number}]${delete file}//button
    click element  ${block}[${block number}]${delete file}//button
    wait until page contains element  ${block}[${block number}]${delete file}${delete file confirm}
    click element  ${block}[${block number}]${delete file}${delete file confirm}


###    Choice type of file     ###
Обрати тип файлу
    [Arguments]  ${block number}  ${type of file number}  ${file number}
    Click Element  ${block}[${block number}]${file button path}[${file number}]${choice file button}
    Click Element  ${block}${choice file list}[${type of file number}]


Отримати всі доступні типи файлі зі словника
    ${list of type files}=  get_tender_variables  ${tender_type}  Document type list
    ${number of file types}  Evaluate  str(len(${list of type files}))
    [Return]  ${number of file types}


Вибрати всі доступні типи файлів
	Run depending on the dict  Document type  Вибрати всі доступні типи файлів продовження


Вибрати всі доступні типи файлів продовження
    ${number of file types}  Отримати всі доступні типи файлі зі словника
    :FOR  ${INDEX}  IN RANGE  1  ${number of file types}+1
    \  Створити та додати PDF файл  0
    \  ${a}  Set Variable  ${INDEX}+1
    \  Обрати тип файлу  1  ${INDEX}  last()


###    Add info    ###
Add info about sub
    [Arguments]  ${block number}
    ${text}  create_sentence
    Input Text  ${block}[${block number}]//textarea  ${text}


Add info about sub LOOP
    :FOR  ${INDEX}  IN RANGE  2  ${blocks amount}
    \  Add info about sub  ${index}


###    Confidentiality    ###
Confidentiality
	[Arguments]  ${block number}  ${doc_count}
	Click element  (${block}[${block number}]${switch})[${doc_count}]
	Sleep  2


File description
	[Arguments]  ${block number}
	${text}  create_sentence
    Input text  ${block}[${block number}]${switch field}  ${text}


###    Other    ###
Run depending on the dict
    [Arguments]  ${tender_sign}  ${keyword}  @{arguments}
    ${variable}  get_tender_variables  ${tender_type}  ${tender_sign}
    Run Keyword If  ${variable} == ${True}
    ...  Run Keyword  ${keyword}  @{arguments}


Змінити ціну
    Заповнити поле з ціною  1  0.9