*** Settings ***


*** Variables ***


*** Keywords ***
Дочекатися відображення елемента на сторінці
	[Documentation]  timeout=...s/...m
	[Arguments]  ${locator}  ${timeout}
	Wait Until Keyword Succeeds  ${timeout}  .5  Element Should Be Visible  ${locator}