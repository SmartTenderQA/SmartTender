*** Settings ***
Resource  ../../src/src.robot
Suite Setup  Відкрити вікна для всіх користувачів
Suite Teardown  Suite Postcondition
Test Teardown  Run Keywords
...  Log Location
...  AND  Run Keyword If Test Failed  Capture Page Screenshot


*** Variables ***
${tender}                           Простой однолотовый
${prepared_tender}                  xpath=//tr[@class='head']/td/a[contains(text(), '${tender}') and @href]
${make proposal link}               xpath=//div[@class='row']//a[contains(@class, 'button')]
${start_page}                       http://smarttender.biz
${webClient loading}                id=LoadingPanel


*** Test Cases ***
Створити тендер
	[Tags]  create_tender
	Switch Browser  tender_owner
	Sleep  2
	Відкрити сторінку для створення аукціону на продаж
	Відкрити вікно створення тендеру
	Wait Until Keyword Succeeds  30  3  Вибрати тип процедури  Голландський аукціон
	Заповнити auctionPeriod.startDate
	Заповнити value.amount
	Заповнити minimalStep.percent
	Заповнити dgfDecisionID
	Заповнити dgfDecisionDate
	Заповнити title
	Заповнити dgfID
	Заповнити description
	Заповнити guarantee.amount
	Заповнити items.description
	Заповнити items.quantity
	Заповнити items.unit.name
	Заповнити items.classification.description
	Заповнити procuringEntity.contactPoint.name
	Зберегти чернетку
	Оголосити тендер
	Отримати та зберегти auctionID
	Звебегти дані в файл


*** Keywords ***
Відкрити вікна для всіх користувачів
	Start  fgv_prod_owner  tender_owner
	Go Back
	#Start  viewer_prod  viewer
	#Start  prod_provider1  provider1
	#Start  prod_provider2  provider2
	${data}  Create Dictionary
	Set Global Variable  ${data}