#!/usr/bin/env python
# -*- coding: utf-8 -*-
# ==============
#      Main script file
# ==============
import sys
import re
import urllib2

from iso8601 import parse_date
from datetime import datetime, timedelta
from dateutil.parser import parse
from dateutil.parser import parserinfo
from glob import glob
import os
import operator


reload(sys)
sys.setdefaultencoding('utf-8')


def get_user_variable(user, users_variable=None):
    a = {
        'ssp_tender_owner': {
            'login': 'USER_SSP',
            'password': 'qwerty123123',
            'name': u'Орган приватизации',
            'role': 'ssp_tender_owner',
            'site': 'test',
        },
        'PPR_TEST_FGI': {
            'login': 'PPR_TEST_FGI',
            'password': 'qwerty123',
            'name': u'Test FGI Public Enterprise',
            'role': 'tender_owner',
            'site': 'test',
        },
        'IT_RAV': {
            'login': 'IT_RAV',
            'password': 'qwerty123',
            'name': u'IT-Руденко А.В.',
            'role': 'tender_owner',
            'site': 'test',
        },
        'Bened': {
            'login': 'PPR_BV',
            'password': '123321',
            'name': '',
            'role': 'tender_owner',
            'site': 'test',
        },
        'fgv_prod_owner': {
            'login': 'IT_TEST_FGV_USER',
            'password': 'fdjh123fdsj',
            'name': u'Тестировщик',
            'role': 'tender_owner',
            'site': 'prod',
        },
        'dasu': {
            'login': 'PPR_TEST',
            'password': 'qwerty123',
            'name': 'Test Public Enterprise',
            'role': 'tender_owner',
            'site': 'test',
        },
        'test_it.ua': {
            'login': 'test@it.ua',
            'password': 'qwerty123',
            'name': u'Тестировщик',
            'role': 'provider',
            'site': 'prod',
        },
        'comm_tender_owner': {
            'login': 'test_com',
            'password': '291263',
            'name': 'test test',
            'role': 'tender_owner',
            'site': 'test',
        },
        'prod_provider1': {
            'login': 'ttostorovich@gmail.com',
            'password': 'qwedfgtyhj[s/',
            'name': u'Тестовый пользователь',
            'role': 'provider',
            'site': 'prod',
            'mail_password': 'qwedfgtyhj[s/',
        },
        'prod_provider2': {
            'login': 'prodsmartprovider2@gmail.com',
            'password': '0c5j1a',
            'name': 'Qa.TestUser4Runner',
            'role': 'provider',
            'site': 'prod',
            'mail_password': 'qwertyprod2',
        },
        'prod_owner': {
            'login': 'PPR_TEST_PROZORRO',
            'password': 'jh3jlkbkj2br',
            'name': u'PPR_TEST_PROZORRO',
            'role': 'tender_owner',
            'site': 'prod',
            'mail_password': '',
        },
        'user1': {
            'login': 'SmartTenderProvider1@gmail.com',
            'password': 'nowihs',
            'name': 'Provider1 SmartTender Tender',
            'role': 'provider',
            'site': 'test',
            'mail_password': 'qwertyuiop[]',
        },
        'user2': {
            'login': 'SmartTenderProvider2@gmail.com',
            'password': 'np3ozi',
            'name': 'Smart Provider Tender',
            'role': 'provider',
            'site': 'test',
            'mail_password': 'qwertyuiop[]',
        },
        'viewer_test': {
            'login': '',
            'password': '',
            'name': '',
            'role': 'viewer',
            'site': 'test',
        },
        'viewer_prod': {
            'login': '',
            'password': '',
            'name': '',
            'role': 'viewer',
            'site': 'prod',
        },
        'LLC': {
            'login': 'ttt@debug.kz',
            'password': 'Qqqqqqqqqq1',
            'name': u'Тест QA',
            'role': 'provider',
            'site': 'prod',
        },
        'wrong user': {
            'login': "I don't exist@gmail.com",
            'password': "gfhyje2456$",
        },
        'empty': {
            'login': '',
            'password': '',
        },
        'deleted': {
            'login': 'ivan@lider.com.ua',
            'password': 'qwerty123',
        },
    }
    if user not in a:
        return user
    else:
        return a[user][users_variable]


def get_tender_variables(tender_type, tender_sign):
    a = {
        'open_trade': {
            'Amount': True,
            'Conformity': True,
            'Document type': True,
            'Document type list': ['Технічний опис предмету закупівлі',
                                   'Підтвердження відповідності кваліфікаційним критеріям',
                                   'Цінова пропозиція'],
            'Confidentiality': False,
            'Sub information': True,
        },
        'open_trade_eng': {
            'Amount': True,
            'Conformity': True,
            'Document type': True,
            'Document type list': ['Технічний опис предмету закупівлі',
                                   'Підтвердження відповідності кваліфікаційним критеріям',
                                   'Документи, що підтверджують відповідність',
                                   'Цінова пропозиція',
                                   'Кошторис'],
            'Confidentiality': True,
            'Sub information': True,
        },
        'below_threshold': {
            'Amount': True,
            'Conformity': False,
            'Document type': False,
            'Confidentiality': False,
            'Sub information': False,
        },
        'negotiation_procedure': {
            'Amount': True,
            'Conformity': True,
            'Document type': True,
            'Document type list': ['Технічний опис предмету закупівлі',
                                   'Підтвердження відповідності кваліфікаційним критеріям',
                                   'Цінова пропозиція'],
            'Confidentiality': False,
            'Sub information': True,
        },
        'competitive_dialog': {
            'Amount': False,
            'Conformity': True,
            'Document type': True,
            'Document type list': ['Технічний опис предмету закупівлі',
                                   'Підтвердження відповідності кваліфікаційним критеріям'],
            'Confidentiality': True,
            'Sub information': True,
        },
        'competitive_dialog_eng': {
            'Amount': False,
            'Conformity': True,
            'Document type': True,
            'Document type list': ['Технічний опис предмету закупівлі',
                                   'Підтвердження відповідності кваліфікаційним критеріям'],
            'Confidentiality': True,
            'Sub information': True,
        },
        'ESCO': {
            'Amount': False,
            'Conformity': True,
            'Document type': True,
            'Document type list': ['Технічний опис предмету закупівлі',
                                   'Підтвердження відповідності кваліфікаційним критеріям',
                                   'Документи, що підтверджують відповідність',
                                   'Цінова пропозиція',
                                   'Кошторис'],
            'Confidentiality': True,
            'Sub information': True,
        },
    }
    if tender_sign == None:
        return a[tender_type]
    else:
        return a[tender_type][tender_sign]


def convert_tender_type(tender_type):
    a = {
        'open_trade': u'Відкриті торги',
        'open_trade_eng': u'Відкриті торги з публікацією англійською мовою',
        'below_threshold': u'Допорогові закупівлі',
        'negotiation_procedure': u'Переговорна процедура для потреб оборони',
        'competitive_dialog': u'Конкурентний діалог 1-ий етап',
        'competitive_dialog_eng': u'Конкурентний діалог з публікацією англійською мовою 1-ий етап',
        'ESCO': u'Відкриті торги для закупівлі енергосервісу',
    }
    return a[tender_type]


def get_number(value):
    str = re.search(u'(?P<amount>[\d.\s]+)', value)
    str_amount = str.group("amount")
    str_amount = str_amount.replace(' ', '')
    amount = float(str_amount)
    return amount


def convert_url(href, IP):
    return str(re.sub('https://smarttender.biz', str(IP), str(href)))


def download_file_and_return_content(url):
    response = urllib2.urlopen(url)
    file_content = response.read()
    return file_content


def smart_get_time(v=0, accuracy='m'):
    delta = int(v)
    time = datetime.now() + timedelta(days=delta)
    if accuracy == 'm':
        return ('{:%d.%m.%Y %H:%M}'.format(time))
    elif accuracy == 's':
        return ('{:%d.%m.%Y %H:%M:%S}'.format(time))
    elif accuracy == 'd':
        return ('{:%d.%m.%Y}'.format(time))


def get_time_now_with_deviation(v, deviation):
    delta = int(v)
    if deviation == 'days':
        time = datetime.now() + timedelta(days=delta)
    elif deviation == 'minutes':
        time = datetime.now() + timedelta(minutes=delta)
    return ('{:%d.%m.%Y %H:%M}'.format(time))


def no_weekend(date):
    date = parse(date, parserinfo(True, False))
    if date.weekday() == 5 or date.weekday() == 6:
        date = date + timedelta(days=2)
    return ('{:%d.%m.%Y}'.format(date))


def convert_data_for_web_client(value):
    without_spaces = value.replace(" ", "")
    without_dots = without_spaces.replace(".", "")
    return without_dots.replace(":", "")


def convert_datetime_to_smart_format(isodate, accuracy='s'):
    iso_dt = parse_date(isodate)
    if accuracy == 's':
        date_string = iso_dt.strftime("%d.%m.%Y %H:%M:%S")
    elif accuracy == 'm':
        date_string = iso_dt.strftime("%d.%m.%Y %H:%M")
    elif accuracy == 'd':
        date_string = iso_dt.strftime("%d.%m.%Y")
    return date_string


def compare_dates_smarttender(l, operator, r):
    left = parse(l, parserinfo(True, False))
    right = parse(r, parserinfo(True, False))
    return get_truth(left, operator, right)


def get_truth(left, oper, right):
    ops = {'>': operator.gt,
           '<': operator.lt,
           '>=': operator.ge,
           '<=': operator.le,
           '==': operator.eq}
    return ops[oper](left, right)


def sleep_to(time):
    end = (parse(time)).replace(tzinfo=None)
    now = datetime.now()
    subtract = end - now
    return subtract.seconds, now


def convert_date_from_cdb(date):
    time = (parse(date)).replace(tzinfo=None)
    time = (time.strftime('%Y-%m-%d %H:%M:%S'))
    return time


def clear_test_output():
    for filename in glob("*.pdf"):
        os.remove(filename)

    for filename in glob("*.png"):
        os.remove(filename)


def get_tender_href_for_commercial_owner(value):
    list = re.search('.*(?P<href>http.+)(?P<ticket>\?ticket=.+)\'.*', value)
    href = list.group('href')
    ticket = list.group('ticket')
    return href, ticket
