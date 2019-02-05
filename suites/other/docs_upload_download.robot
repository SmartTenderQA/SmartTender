*** Settings ***
Resource  				../../src/src.robot

Suite Setup  			Додати першого користувача  prod_ssp_owner
Suite Teardown  		Close All Browsers
Test Teardown  			Run Keywords
						...  Log Location  AND
						...  Run Keyword If Test Failed  Capture Page Screenshot
#  robot --consolecolors on -L TRACE:INFO -d test_output suites/other/docs_upload_download.robot

*** Test Cases ***
Перейти до об'єктів малої приватизації
    start_page.Натиснути на іконку з баннеру  Комерційні тендери SmartTender
	old_search.Активувати вкладку ФГИ
	small_privatization_search.Активувати вкладку  Реєстр об'єктів приватизації


Виконати пошук потрібного обєкту
    small_privatization_search.Вибрати режим сторінки об'єктів приватизації  Кабінет
    new_search.Ввести фразу для пошуку  UA-AR-P-2018-12-10-000004-3
    small_privatization_search.Натиснути кнопку пошуку
    small_privatization_search.Перейти по результату пошуку за номером  1


Створити файли розміром більше 2mb та з довгою назвою
    ${1 full name}  Створити великий PDF файл з довгою назвою  first
    Set Global Variable  ${1 full name}
    ${2 full name}  Створити великий PDF файл з довгою назвою  second
    Set Global Variable  ${2 full name}


Загрузити файли до об'єкту приватизації
    #Видалити файли з об'єкту приватизації  # На випадок якщо, файли не видалились коли тест зафейлився
    small_privatization_object.Натиснути кнопку "Коригувати об'єкт приватизації"
    Загрузити файл  ${1 full name}
    Загрузити файл  ${2 full name}
    small_privatization_object.Натиснути кнопку зберегти


Перевірка загрузки файлів
    Wait Until Keyword Succeeds  2m  5s
    ...  Перевірити усрішність додавання файлів  ${1 full name}  ${2 full name}


Скачати загружені файли
    Створити папку загрузок
    Скачати файли об'єкту приватизації     ${1 full name}  ${2 full name}


Отримати дані з cdb та зберегти їх у файл
    Створити словник  cdb
    ${cdb}  Отримати дані об'єкту приватизації з cdb по id  41fef353ba5648158c0d38dd41305afa
    Set Global Variable  ${cdb}
    Зберегти словник у файл  ${cdb}  cdb


Отримати контрольні суми файлів з ЦБД, до загрузки та після скачування та порівняти їх
    ${cdb md5 first}   Отримати md5 файлу із словника ЦБД   ${1 full name}
    ${md5 first}       get_checksum_md5  ${OUTPUTDIR}/${1 full name}
    ${now md5 first}   get_checksum_md5  ${OUTPUTDIR}/downloads/${1 full name}

    ${cdb md5 second}  Отримати md5 файлу із словника ЦБД  ${2 full name}
    ${md5 second}      get_checksum_md5  ${OUTPUTDIR}/${2 full name}
    ${now md5 second}  get_checksum_md5  ${OUTPUTDIR}/downloads/${2 full name}

    Should Be Equal    ${cdb md5 first}   ${md5 first}   ${now md5 first}
    Should Be Equal    ${cdb md5 second}  ${md5 second}  ${now md5 second}





*** Keywords ***
Створити папку загрузок
    Create Directory  ${OUTPUTDIR}/downloads/


Загрузити файл
    [Arguments]  ${file}
    Choose File  ${button add file}  ${OUTPUTDIR}/${file}
    Sleep  2


Отримати md5 файлу із словника ЦБД
    [Arguments]  ${file name}
    ${n}  small_privatization_object.Отримати кілкість документів обєкту приватизації
    :FOR  ${i}  IN RANGE  ${n}+1
    \  ${title}  Get From Dictionary  ${cdb['documents'][${i}]}  title
    \  ${md5}  Run Keyword If  '${title}' == '${file name}'  Get From Dictionary  ${cdb['documents'][${i}]}  hash
    \  Exit For Loop If  '${md5}' != 'None'
    [Return]  ${md5[4:]}


Створити великий PDF файл з довгою назвою
    [Arguments]  ${name}
    ${n}  random_number  1  1000
    ${long name}  Evaluate  '1' * 200 + ' ${name}' + ' ${n}'
    ${file path}  Set Variable  ${OUTPUTDIR}/${long name}.pdf
    ${content}  Evaluate  '${name} file ' * 1024 * 256
    Create File  ${file path}  ${content}
    ${full name}  Set Variable  ${long name}.pdf
    [Return]  ${full name}


Перевірити усрішність додавання файлів
    [Arguments]  @{file_names}
    Reload Page
    Sleep  2
    :FOR  ${file}  IN  @{file_names}
    \  Page Should Contain Element  //*[@data-qa="file-name"][text()="${file}"]


Скачати файли об'єкту приватизації
    [Arguments]  @{file names}
   :FOR  ${file}  IN  @{file_names}
    \  ${selector}  Set Variable  //*[@data-qa="file-name"][text()="${file}"]
    \  Mouse Over  ${selector}/preceding-sibling::i
    \  Wait Until Element Is Visible  ${selector}/ancestor::div[@class="ivu-poptip"]//a[@data-qa="file-preview"]  15
    \  ${link}  Get Element Attribute  ${selector}/ancestor::div[@class="ivu-poptip"]//a[@data-qa="file-preview"]  href
    \  ${link}  Evaluate  re.search(r'(?P<href>.+)&view=g', '${link}').group('href')  re
    \  download_file_to_my_path  ${link}  ${OUTPUTDIR}/downloads/${file}
    \  Sleep  3
