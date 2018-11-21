*** Settings ***
Documentation    Suite description
Library  			faker.py

*** Keywords ***
Створити та додати файл
  [Arguments]  ${selector}
  ${path}  ${name}  ${content}  Створити файл
  Choose File  ${selector}  ${path}
  [Return]  ${path}  ${name}  ${content}


Створити файл
	${file}  create_fake_doc
	${path}  Set Variable  ${file[0]}
	${name}  Set Variable  ${file[1]}
	${content}  Set Variable  ${file[2]}
	[Return]  ${path}  ${name}  ${content}