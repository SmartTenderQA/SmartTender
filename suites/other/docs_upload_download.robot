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
    Відкрити сторінку тестових торгів
    Активувати вкладку ФГВ
    Перейти на вкладку "Реєстр об'єктів приватизації"


Відкрити потрібний об'єкт
    Вибрати режим сторінки  Кабинет
    Перейти до об'єкта приватизації за назвою  [ТЕСТУВАННЯ] Перевірка загрузки документів
    Видалити файли з об'єкту приватизації


Перевірка загрузки та вигрузки файлів
    Натиснути кнопку "Коригувати об'єкт приватизації"
    ${1 full name}  Створити та додати великий PDF файл з довгою назвою  first
    ${md5 first}  get_checksum_md5  ${OUTPUTDIR}/${1 full name}
    ${2 full name}  Створити та додати великий PDF файл з довгою назвою  second
    ${md5 second}  get_checksum_md5  ${OUTPUTDIR}/${2 full name}
    Натиснути кнопку "Внести зміни"
    Перевірити усрішність додавання файлів  first  second
    Створити папку загрузок
    Перевірити можливість скачати файли     ${1 full name}  ${2 full name}
    ${now md5 first}  get_checksum_md5  ${OUTPUTDIR}/downloads/${1 full name}
    ${now md5 second}  get_checksum_md5  ${OUTPUTDIR}/downloads/${2 full name}
    Should Be Equal  ${md5 first}   ${now md5 first}
    Should Be Equal  ${md5 second}  ${now md5 second}


Видалити загружені файли
    Видалити файли з об'єкту приватизації





*** Keywords ***
Створити папку загрузок
    Create Directory  ${OUTPUTDIR}/downloads/


Перейти на вкладку "Реєстр об'єктів приватизації"
    Click Element  //*[@data-qa="registry"]
    Дочекатись закінчення загрузки сторінки(skeleton)
    Element Should Be Visible
    ...  //*[@class="tab-pane tab-pane-active"][@data-qa="registry"]


Вибрати режим сторінки
    [Arguments]  ${type}
    ${selector}  Set Variable  //*[@data-qa="page-mode"]//span[text()="${type}"]
    Click Element   ${selector}
    Sleep  .5
    Element Should Be Visible
    ...  ${selector}/preceding-sibling::span[contains(@class,"radio-checked")]


Перейти до об'єкта приватизації за назвою
    [Arguments]  ${title}
    ${selector}  Set Variable  //div[contains(@class,"asset-card")]//a[text()="${title}"]
    Open Button  ${selector}
    Дочекатись закінчення загрузки сторінки(skeleton)
    Wait Until Element Is Visible  //h3[text()="${title}"]


Натиснути кнопку "Коригувати об'єкт приватизації"
     Click Element  //*[@data-qa="button-to-edit-page"]
     Дочекатись закінчення загрузки сторінки(skeleton)
     Location Should Contain  /privatization-objects/edit/


Створити та додати великий PDF файл з довгою назвою
    [Arguments]  ${name}
    ${long name}  Evaluate  '1' * 200 + ' ${name}'
    ${file path}  Set Variable  ${OUTPUTDIR}/${long name}.pdf
    ${content}  Evaluate  '${name} file ' * 1024 * 256
    Create File  ${file path}  ${content}
    Choose File  ${button add file}  ${file path}
    ${full name}  Set Variable  ${long name}.pdf
    [Return]  ${full name}


Натиснути кнопку "Внести зміни"
    Click Element  //*[@data-qa="button-success"]/span
    Sleep  3
    Дочекатись закінчення загрузки сторінки(skeleton)
    ${status}  Run Keyword And Return Status  Element Should Not Be visible  //*[@data-qa="button-success"]/span
    Run Keyword If  '${status}' == 'False'  Натиснути кнопку "Внести зміни"


Перевірити усрішність додавання файлів
    [Arguments]  @{file_names}
    ${i}  Evaluate  1
    :FOR  ${file}  IN  @{file_names}
    \  ${name}  Get Text  (//*[@data-qa="file-name"])[${i}]
    \  ${name lenght}  Get Length  ${name}
    \  Should Be True  ${name lenght} > 200
    \  Should Contain  ${name}  ${file}
    \  ${size}  Get Text  (//*[@data-qa="file-size"])[${i}]
    \  ${size}  Evaluate  re.search(r'(?P<size>\\d+.\\d+)', u'${size}').group('size')  re
    \  ${size}  Evaluate  float(${size})
    \  Should Be True  ${size} > 2
    \  ${i}  Evaluate  ${i} + 1


Перевірити можливість скачати файли
    [Arguments]  @{file names}
    ${n}  Отримати кілкість документів обєкту приватизації
    :FOR  ${i}  IN RANGE  1  ${n}+1
    \  Mouse Over  (//*[@data-qa="file-name"])[${i}]/preceding-sibling::i
    \  Wait Until Element Is Visible  (//*[@data-qa="file-download"])[${i}]
    \  ${link}  Get Element Attribute  (//*[@data-qa="file-preview"])[${i}]  href
    \  ${link}  Evaluate  re.search(r'(?P<href>.+)&view=g', '${link}').group('href')  re
    \  download_file_to_my_path  ${link}  ${EXECDIR}/test_output/downloads/${file names[${i}-1]}
    \  Sleep  3


Отримати кілкість документів обєкту приватизації
    ${selector}  Set Variable  //*[@data-qa="file-name"]
    ${count}  Get Element Count  ${selector}
    [Return]  ${count}


Видалити файли з об'єкту приватизації
    ${n}  Отримати кілкість документів обєкту приватизації
    Scroll Page To Top
    Натиснути кнопку "Коригувати об'єкт приватизації"
    :FOR  ${file}  IN RANGE  1  ${n}+1
    \  Click Element  (//i[contains(@class,"icon-trash")])[1]
    \  Wait Until Element Is Visible  (//*[@class="ivu-poptip-footer"])[1]//span[text()="Так"]
    \  Click Element  (//*[@class="ivu-poptip-footer"])[1]//span[text()="Так"]
    \  Sleep  .5
    Scroll Page To Top
    Натиснути кнопку "Внести зміни"
    ${n}  Отримати кілкість документів обєкту приватизації
    Should Be Equal As Integers  ${n}  0
