*** Settings ***


*** Variables ***


*** Keywords ***
Дочекатися відображення елемента на сторінці
	[Documentation]  timeout=...s/...m
	[Arguments]  ${locator}  ${timeout}=10s
	Wait Until Keyword Succeeds  ${timeout}  .5  Element Should Be Visible  ${locator}


Дочекатися зникнення елемента зі сторінки
	[Documentation]  timeout=...s/...m
	[Arguments]  ${locator}  ${timeout}=10s
	Wait Until Keyword Succeeds  ${timeout}  .5  Element Should Not Be Visible  ${locator}