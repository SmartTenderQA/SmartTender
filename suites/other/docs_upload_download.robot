*** Settings ***
Resource  				../../src/src.robot

Suite Setup  			Start  prod_ssp_owner
Suite Teardown  		Close All Browsers
Test Teardown  			Run Keywords
						...  Log Location  AND
						...  Run Keyword If Test Failed  Capture Page Screenshot
#  robot --consolecolors on -L TRACE:INFO -d test_output suites/other/docs_upload_download.robot

*** Test Cases ***
Перейти до об'єктів малої приватизації
    small_privatization.Перейти на сторінку малої приватизації
    small_privatization.Перейти на сторінку реєстр об'єктів приватизації


Виконати пошук потрібного обєкту
    small_privatization_search.Вибрати режим сторінки об'єктів приватизації  Кабінет
    #new_search.Ввести фразу для пошуку  UA-AR-P-2018-12-07-000002-2
    #small_privatization_search.Натиснути кнопку пошуку
    small_privatization_search.Перейти по результату пошуку за номером  3


Створити файли розміром більше 2mb та з довгою назвою
    ${1 full name}  Створити великий PDF файл з довгою назвою  first
    Set Global Variable  ${1 full name}
    ${2 full name}  Створити великий PDF файл з довгою назвою  second
    Set Global Variable  ${2 full name}


Загрузити файли до об'єкту приватизації
    Видалити файли з об'єкту приватизації  # На випадок якщо, файли не видалились коли тест зафейлився
    small_privatization_object.Натиснути кнопку "Коригувати об'єкт приватизації"
    Загрузити файли  ${1 full name}  ${2 full name}
    small_privatization_object.Зберегти зміни об'єкту


Перевірка загрузки файлів
    Перевірити усрішність додавання файлів  ${1 full name}  ${2 full name}


Скачати загружені файли
    Створити папку загрузок
    Скачати файли об'єкту приватизації     ${1 full name}  ${2 full name}


Порівняти контрольні сумми файлів до загрузки та після скачування
    ${md5 first}       get_checksum_md5  ${OUTPUTDIR}/${1 full name}
    ${now md5 first}   get_checksum_md5  ${OUTPUTDIR}/downloads/${1 full name}
    Should Be Equal    ${md5 first}      ${now md5 first}
    ${md5 second}      get_checksum_md5  ${OUTPUTDIR}/${2 full name}
    ${now md5 second}  get_checksum_md5  ${OUTPUTDIR}/downloads/${2 full name}
    Should Be Equal    ${md5 second}     ${now md5 second}


Видалити загружені файли
    Видалити файли з об'єкту приватизації





*** Keywords ***
Створити папку загрузок
    Create Directory  ${OUTPUTDIR}/downloads/


Загрузити файли
    [Arguments]  @{file_names}
    :FOR  ${file}  IN  @{file_names}
    \  Choose File  ${button add file}  ${OUTPUTDIR}/${file}


Створити великий PDF файл з довгою назвою
    [Arguments]  ${name}
    ${long name}  Evaluate  '1' * 200 + ' ${name}'
    ${file path}  Set Variable  ${OUTPUTDIR}/${long name}.pdf
    ${content}  Evaluate  '${name} file ' * 1024 * 256
    Create File  ${file path}  ${content}
    ${full name}  Set Variable  ${long name}.pdf
    [Return]  ${full name}


Перевірити усрішність додавання файлів
    [Arguments]  @{file_names}
    ${i}  Evaluate  1
    :FOR  ${file}  IN  @{file_names}
    \  ${name}  Get Text  (//*[@data-qa="file-name"])[${i}]
    \  ${name lenght}  Get Length  ${name}
    \  Should Be True  ${name lenght} > 200
    \  Should Be Equal  ${name}  ${file}
    #\  ${size}  Get Text  (//*[@data-qa="file-size"])[${i}]
    #\  ${size}  Evaluate  re.search(r'(?P<size>\\d+.\\d+)', u'${size}').group('size')  re
    #\  ${size}  Evaluate  float(${size})
    #\  Should Be True  ${size} > 2
    \  ${i}  Evaluate  ${i} + 1


Скачати файли об'єкту приватизації
    [Arguments]  @{file names}
    ${n}  small_privatization_object.Отримати кілкість документів обєкту приватизації
    :FOR  ${i}  IN RANGE  1  ${n}+1
    \  Mouse Over  (//*[@data-qa="file-name"])[${i}]/preceding-sibling::i
    \  Wait Until Element Is Visible  (//*[@data-qa="file-download"])[${i}]
    \  ${link}  Get Element Attribute  (//*[@data-qa="file-preview"])[${i}]  href
    \  ${link}  Evaluate  re.search(r'(?P<href>.+)&view=g', '${link}').group('href')  re
    \  download_file_to_my_path  ${link}  ${OUTPUTDIR}/downloads/${file names[${i}-1]}
    \  Sleep  3



Видалити файли з об'єкту приватизації
    ${n}  small_privatization_object.Отримати кілкість документів обєкту приватизації
    #Scroll Page To Top
    small_privatization_object.Натиснути кнопку "Коригувати об'єкт приватизації"
    :FOR  ${file}  IN RANGE  1  ${n}+1
    \  Click Element  (//i[contains(@class,"icon-trash")])[1]
    \  Wait Until Element Is Visible  (//*[@class="ivu-poptip-footer"])[1]//span[text()="Так"]
    \  Click Element  (//*[@class="ivu-poptip-footer"])[1]//span[text()="Так"]
    \  Sleep  .5
    small_privatization_object.Зберегти зміни об'єкту
    ${n}  small_privatization_object.Отримати кілкість документів обєкту приватизації
    Should Be Equal As Integers  ${n}  0
