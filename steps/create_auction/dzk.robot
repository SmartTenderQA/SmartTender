*** Keywords ***
Створити тендер
	start_page.Натиснути На торговельний майданчик
	old_search.Активувати вкладку ФГИ
	Run Keyword If  '${site}' == 'test'
	...  small_privatization_search.Активувати перемемик тестового режиму на  вкл
	dzk_auction.Натиснути створити аукціон
	dzk.Заповнити "Номер лоту"
	dzk.Заповнити "Найменування лоту"
	dzk.Заповнити "Опис лоту"
	dzk.Заповнити "Інформацію про організатора"
	dzk.Заповнити "Інформацію про контактну особу"
	dzk.Заповнити "Інформацію про умови аукціону"
	dzk.Заповнити "Банківські реквізити"
	dzk.Заповнити "Реквізити для перерахування реєстраційних внесків"
	dzk.
	dzk.
	dzk.




	dzk_auction.Заповнити lotHolder.identifier.legalName
	dzk_auction.Заповнити lotHolder.identifier.id
	dzk_auction.Заповнити lotHolder.address.postalCode
	dzk_auction.Заповнити lotHolder.address.locality
	dzk_auction.Заповнити lotHolder.address.streetAddress
	dzk_auction.Заповнити lotHolder.contactPoint.name
	dzk_auction.Заповнити lotHolder.contactPoint.email
	dzk_auction.Заповнити auctionPeriod.shouldStartAfter
	dzk_auction.Заповнити tenderAttempts
	dzk_auction.Заповнити minNumberOfQualifiedBids
	dzk_auction.Заповнити contractTerms.leaseTerms.years
	dzk_auction.Заповнити contractTerms.leaseTerms.months
	dzk_auction.Заповнити value.amount
	dzk_auction.Заповнити minimalStep.amount
	dzk_auction.Заповнити guarantee.amount
	dzk_auction.Заповнити budgetSpent.amount
	dzk_auction.Заповнити registrationFee.amount
	dzk_auction.Заповнити bankAccount.bankName
	dzk_auction.Заповнити bankAccount.accountIdentification.0.description
	dzk_auction.Заповнити bankAccount.accountIdentification.(num).id
	dzk_auction.Заповнити items.0.description
	dzk_auction.Заповнити items.0.additionalClassifications.1.id
	dzk_auction.Заповнити items.0.classification.description
	dzk_auction.Заповнити items.0.additionalClassifications.description
	dzk_auction.Заповнити items.0.quantity
	dzk_auction.Заповнити items.0.unit.name
	dzk_auction.Заповнити items.0.address.postalCode
	dzk_auction.Заповнити items.0.address.locality
	dzk_auction.Заповнити items.0.address.streetAddress
	###

	Перейти у розділ (webclient)  Рамочные соглашения(тестовые)
	Натиснути додати(F7)  Додавання. Тендери
  	create_tender.Вибрати тип процедури  Укладання рамкової угоди
    test_ramky.Заповнити кількість учасників для укладання РУ
    test_ramky.Заповнити "Срок рамкової угоди"
  	test_ramky.Заповнити endDate періоду пропозицій
  	test_ramky.Заповнити amount для lot
  	test_ramky.Заповнити minimalStep для lot
  	test_ramky.Заповнити title для tender
  	test_ramky.Заповнити description для tender
  	test_ramky.Заповнити title_eng для tender
  	test_ramky.Додати предмет в тендер
    Додати документ до тендара власником (webclient)
    Зберегти чернетку
    Оголосити закупівлю


#########################################################
#	                  Keywords							#
#########################################################
Заповнити "Номер лоту"
	${lotNumber}  random_number  10000  1000000
	dzk_auction.Заповнити lotIdentifier  ${lotNumber}
	Set To Dictionary  ${dzk_data}  lotIdentifier  ${lotNumber}


Заповнити "Найменування лоту"
	${title}  create_sentence  5
	dzk_auction.Заповнити title  ${title}
	Set To Dictionary  ${dzk_data}  title  ${title}


Заповнити "Опис лоту"
	${description}  create_sentence  20
	dzk_auction.Заповнити description  ${description}
	Set To Dictionary  ${dzk_data}  description  ${description}


Заповнити "Інформацію про організатора"
	Заповнити "Назва організатора"
	Заповнити "Код ЄДРПОУ організатора"
	Заповнити "Поштовий індекс організатора"
	Заповнити "Місто організатора"
	Заповнити "Вулиця організатора"


Заповнити "Назва організатора"
	${legalName}  create_sentence  2
	dzk_auction.Заповнити lotHolder.identifier.legalName  ${legalName}
	Set To Dictionary  ${dzk_data['lotHolder']['identifier']}  legalName  ${legalName}


Заповнити "Код ЄДРПОУ організатора"
	${id}  random_number  10000  100000
	dzk_auction.Заповнити lotHolder.identifier.id
	Set To Dictionary  ${dzk_data['lotHolder']['identifier']}  id  ${id}


Заповнити "Поштовий індекс організатора"
	${postalCode}  random_number  10000  99999
	dzk_auction.Заповнити lotHolder.address.postalCode
	Set To Dictionary  ${dzk_data['lotHolder']['address']}  postalCode  ${postalCode}


Заповнити "Місто організатора"
	${locality}  dzk_auction.Заповнити lotHolder.address.locality
	${region}  Evaluate  (re.findall(r'[А-я][^(]+[.]','${locality}'))[0]  re
	Set To Dictionary  ${dzk_data['lotHolder']['address']}  region  ${region}
	${locality}  Evaluate  re.sub(r'.[(].*','','${locality}')  re
	Set To Dictionary  ${dzk_data['lotHolder']['address']}  locality  ${locality}


Заповнити "Вулиця організатора"
	${streetAddress}  get_some_uuid
	dzk_auction.Заповнити lotHolder.address.streetAddress  ${streetAddress}
	Set To Dictionary  ${dzk_data['lotHolder']['address']}  streetAddress  ${streetAddress}


Заповнити "Інформацію про контактну особу"
	Заповнити "ПІБ контактної особи"
	Заповнити "Телефон контактної особи"
	Заповнити "Факс контактної особи"
	Заповнити "Email контактної особи"
	Заповнити "URL контактної особи"


Заповнити "ПІБ контактної особи"
	${name}  create_sentence  3
	dzk_auction.Заповнити lotHolder.contactPoint.name  ${name}
	Set To Dictionary  ${dzk_data['lotHolder']['contactPoint']}  name  ${name}


Заповнити "Телефон контактної особи"
	No Operation


Заповнити "Факс контактної особи"
	No Operation


Заповнити "Email контактної особи"
	${text}  Generate Random String  6  [LETTERS][NUMBERS]
	${email}  Set Variable  ${text}@gmail.com
	dzk_auction.Заповнити lotHolder.contactPoint.email  ${email}
	Set To Dictionary  ${dzk_data['lotHolder']['contactPoint']}  email  ${email}


Заповнити "URL контактної особи"
	No Operation


Заповнити "Інформацію про умови аукціону"
	Заповнити "Дата проведення аукціону"
	Заповнити "Лоти виставляються"
	Заповнити "Мінімальна кількість учасників аукціону"
	Заповнити "Тривалість оренди Років"
	Заповнити "Тривалість оренди Місяців"
	Заповнити "Стартова ціна об’єкта"
	Заповнити "Крок електронного аукціону"
	Заповнити "Розмір гарантійного внеску"
	Заповнити "Вартість підготовки лоту до торгів"
	Заповнити "Реєстраційний внесок"


Заповнити "Дата проведення аукціону"
	${delta minutes}  Set Variable  33
	${start}  Evaluate  '{:%d.%m.%Y %H:%M:%S}'.format(datetime.datetime.now() + datetime.timedelta(minutes=int(${delta minutes})))  datetime
	${start without s}  Evaluate  re.sub(r'.{3}$','','${start}')  re
	dzk_auction.Заповнити auctionPeriod.shouldStartAfter  ${start}
	Set To Dictionary  ${dzk_data['auctionPeriod']}  shouldStartAfter  ${start without s}
	#todo tut kostil`


Заповнити "Лоти виставляються"
	${tenderAttempts}  dzk_auction.Заповнити tenderAttempts
	Set To Dictionary  ${dzk_data}  tenderAttempts  ${tenderAttempts}


Заповнити "Мінімальна кількість учасників аукціону"
	${minNumberOfQualifiedBids}  dzk_auction.Заповнити minNumberOfQualifiedBids
	Set To Dictionary  ${dzk_data}  minNumberOfQualifiedBids  ${minNumberOfQualifiedBids}


Заповнити "Тривалість оренди Років"
	${years}  random_number  1  100
	dzk_auction.Заповнити contractTerms.leaseTerms.years  ${years}
	Set To Dictionary  ${dzk_data['contractTerms']['leaseTerms']}  years  ${years}
	${leaseDuration}  Set Variable If
	...  '${dzk_data['contractTerms']['leaseTerms']['leaseDuration']}' == ''  P0Y0M
	...  '${dzk_data['contractTerms']['leaseTerms']['leaseDuration']}' != ''  ${dzk_data['contractTerms']['leaseTerms']['leaseDuration']}
	${leaseDuration}  Evaluate  re.sub(r'P[0-9]*Y', 'P${years}Y', '${leaseDuration}')  re
	Set To Dictionary  ${dzk_data['contractTerms']['leaseTerms']}  leaseDuration  ${leaseDuration}


Заповнити "Тривалість оренди Місяців"
	${months}  random_number  1  12
	dzk_auction.Заповнити contractTerms.leaseTerms.months  ${months}
	Set To Dictionary  ${dzk_data['contractTerms']['leaseTerms']}  months  ${months}
	${leaseDuration}  Set Variable If
	...  '${dzk_data['contractTerms']['leaseTerms']['leaseDuration']}' == ''  P0Y0M
	...  '${dzk_data['contractTerms']['leaseTerms']['leaseDuration']}' != ''  ${dzk_data['contractTerms']['leaseTerms']['leaseDuration']}
	${leaseDuration}  Evaluate  re.sub(r'Y[0-9]*M', 'Y${months}M', '${leaseDuration}')  re
	Set To Dictionary  ${dzk_data['contractTerms']['leaseTerms']}  leaseDuration  ${leaseDuration}


Заповнити "Стартова ціна об’єкта"
	${value}  random_number  10000  500000
	dzk_auction.Заповнити value.amount  ${value}
	Set To Dictionary  ${dzk_data['value']}  amount  ${value}


Заповнити "Крок електронного аукціону"
	${minimalStep}  random_number  100  10000
	dzk_auction.Заповнити minimalStep.amount  ${minimalStep}
	Set To Dictionary  ${dzk_data['minimalStep']}  amount  ${minimalStep}


Заповнити "Розмір гарантійного внеску"
	${guarantee}  random_number  100  1000
	dzk_auction.Заповнити guarantee.amount  ${guarantee}
	Set To Dictionary  ${dzk_data['guarantee']}  amount  ${guarantee}


Заповнити "Вартість підготовки лоту до торгів"
	${budgetSpent}  random_number  100  1000
	dzk_auction.Заповнити budgetSpent.amount  ${budgetSpent}
	Set To Dictionary  ${dzk_data['budgetSpent']}  amount  ${budgetSpent}


Заповнити "Реєстраційний внесок"
	${registrationFee}  random_number  100  1000
	dzk_auction.Заповнити registrationFee.amount  ${registrationFee}
	Set To Dictionary  ${dzk_data['registrationFee']}  amount  ${registrationFee}


Заповнити "Банківські реквізити"
	Заповнити "Найменування банку"
	Заповнити "Опис банку"


Заповнити "Найменування банку"
	${bankName}  create_sentence  5
	dzk_auction.Заповнити bankAccount.bankName  ${bankName}
	Set To Dictionary  ${dzk_data['bankAccount']}  bankName  ${bankName}


Заповнити "Опис банку"
	No Operation


Заповнити "Реквізити для перерахування реєстраційних внесків"
	Заповнити ""
	Заповнити ""
	Заповнити ""
###
Заповнити "Додати предмет в тендер"
###
Заповнити ""
###
Заповнити ""
###
Заповнити ""
###
Заповнити ""
###