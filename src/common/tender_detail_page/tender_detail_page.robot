*** Keywords ***

Переглянути файл за іменем
    [Arguments]  ${file}
    ${link}  Отримати посилання на перегляд файлу  ${file}
    Go To  ${link}


Скачати файл на сторінці
    [Arguments]  ${file}
    ${link}  Отримати посилання на перегляд файлу  ${file}
    ${link}  Evaluate  re.search(r'(?P<href>.+)&view=g', '${link}').group('href')  re
    download_file_to_my_path  ${link}  ${OUTPUTDIR}/${file}
    Sleep  3


Отримати посилання на перегляд файлу
    [Arguments]  ${file}
    ${selector}  Set Variable  //*[@data-qa="file-name"][text()="${file}"]
    Mouse Over  ${selector}/preceding-sibling::i
    Wait Until Element Is Visible  ${selector}/ancestor::div[@class="ivu-poptip"]//a[@data-qa="file-preview"]
    ${link}  Get Element Attribute  ${selector}/ancestor::div[@class="ivu-poptip"]//a[@data-qa="file-preview"]  href
    ${link}  Поправити лінку для IP  ${link}
    [Return]  ${link}