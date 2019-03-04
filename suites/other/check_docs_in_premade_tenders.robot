*** Settings ***
Resource  ../../src/src.robot
Suite Setup			 Preconditions
Suite Teardown  		 Close All Browsers
Test Teardown    		 Run Keywords
						 ...  Log Location  AND
						 ...  Run Keyword If Test Failed  Capture Page Screenshot


#  robot --consolecolors on -L TRACE:INFO -v where:test -v browser:chrome -d test_output -v hub:none -v type:commercial suites/other/check_docs_in_premade_tenders.robot
*** Variables ***
@{files}                image.bmp  word.doc  word.docx  image.jpeg  pdf.pdf  excel.xls  excel.xlsx

&{tenders test}          commercial=https://test.smarttender.biz/komertsiyni-torgy/4094755/
                    ...  procurement=https://test.smarttender.biz/publichni-zakupivli-prozorro/4094017/
                    ...  sales=https://test.smarttender.biz/auktsiony-na-prodazh-aktyviv-derzhpidpryemstv/4094093/

&{tenders prod}          commercial=https://test.smarttender.biz/komertsiyni-torgy/4091529
                    ...  procurement=https://smarttender.biz/publichni-zakupivli-prozorro/6226853/
                    ...  sales=https://smarttender.biz/auktsiony-na-prodazh-aktyviv-derzhpidpryemstv/6227568/

&{tenders pre_prod}      commercial=https://test.smarttender.biz/komertsiyni-torgy/4091529
                    ...  procurement=http://iis9.smarttender.biz.int/publichni-zakupivli-prozorro/6226853/
                    ...  sales=http://iis8.smarttender.biz.int/auktsiony-na-prodazh-aktyviv-derzhpidpryemstv/6227568/
*** Test Cases ***
Перевірити документи в тендері
    [Setup]  No Operation
    [Template]  Перегляд документів в тендері за назвою
    pdf.pdf
    word.docx
    word.doc
    image.bmp
    image.jpeg
    excel.xls
    excel.xlsx


*** Keywords ***
Preconditions
    ${user}  Set Variable If  "prod" in "${where}"  prod_viewer  test_viewer
    ${tender URLs}  Set Variable If  "prod" in "${where}"  &{tenders prod}  &{tenders test}
   	Set Global Variable  ${user}  ${user}
	Open Browser In Grid  ${user}


Перевірити відсутність помилок на сторінці перегляду документу
    ${location}  Get Location
	Should Not Contain  ${location}  error
	Page Should Not Contain  an error
	Page Should Not Contain  омилка


Перегляд документів в тендері за назвою
    [Arguments]  ${file_name}
    ${keyword_file}  Run Keyword If  '${type}' == 'commercial'  Set Variable  komertsiyni_torgy_tender_detail_page
    ...  ELSE IF  '${type}' == 'procurement'  Set Variable  procurement_tender_detail
    ...  ELSE  Set Variable  auction_detail_page
    Go to  ${tenders ${where}}[${type}]
    Дочекатись закінчення загрузки сторінки
    Run Keyword  ${keyword_file}.Переглянути файл за іменем  ${file_name}
    Перевірити відсутність помилок на сторінці перегляду документу
