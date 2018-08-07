#!/usr/bin/env python
# -*- coding: utf-8 -*-
# ==============
#      Main script file
# ==============
import sys
import urllib2

reload(sys)
sys.setdefaultencoding('utf-8')


import re
from random import randint
from datetime import datetime, timedelta


def get_user_variable(user, users_variable):
    a = {
        'tender_owner': {
            'login': 'USER_SSP',
            'password': 'qwerty123123',
            'name': u'Орган приватизации',
        },
        'Bened': {
            'login': 'PPR_BV',
            'password': '123321',
            'name': '',
        },
        'test_it.ua': {
            'login': 'test@it.ua',
            'password': 'qwerty123',
            'name': 'Тестировщик',
        },
        'fgv_prod_owner': {
            'login': 'IT_TEST_FGV_USER',
            'password': 'fdjh123fdsj',
            'name': 'Тестировщик',
        },
        'user1': {
            'login': 'SmartTenderProvider1@gmail.com',
            'password': 'nowihs',
            'name': 'Provider1 SmartTender Tender',
        },
        'user2': {
            'login': 'SmartTenderProvider2@gmail.com',
            'password': 'np3ozi',
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
        }
    }
    return a[user][users_variable]


def get_tender_variables(tender_form, tender_sign):
    a = {
        'open_trade': {
            'One_lot': '3164571',
            'Multiple': '3164573',
            'Simple': '3164574',
            'Amount': True,
            'Conformity': True,
            'Document type': True,
            'Document type list': ['Технічний опис предмету закупівлі',
                                   'Підтвердження відповідності кваліфікаційним критеріям',
                                   'Цінова пропозиція'],
            'Confidentiality': False,
            'Description': False,
            'Sub information': True,
            'Useful indicators': True,
        },
        'open_trade_eng': {
            'One_lot': '3164929',
            'Multiple': '3164930',
            'Simple': '3164932',
            'Amount': True,
            'Conformity': True,
            'Document type': True,
            'Document type list': ['Технічний опис предмету закупівлі',
                                   'Підтвердження відповідності кваліфікаційним критеріям',
                                   'Документи, що підтверджують відповідність',
                                   'Цінова пропозиція',
                                   'Кошторис'],
            'Confidentiality': True,
            'Description': True,
            'Sub information': True,
            'Useful indicators': True,
        },
        'below_threshold': {
            'One_lot': '3164321',
            'Multiple': '3164332',
            'Simple': '3164557',
            'Amount': True,
            'Conformity': False,
            'Document type': False,
            'Confidentiality': False,
            'Description': False,
            'Sub information': False,
            'Useful indicators': True,
        },
        'negotiation_procedure': {
            'One_lot': '3164934',
            'Multiple': '3164935',
            'Simple': '3164936',
            'Amount': True,
            'Conformity': True,
            'Document type': True,
            'Document type list': ['Технічний опис предмету закупівлі',
                                   'Підтвердження відповідності кваліфікаційним критеріям',
                                   'Цінова пропозиція'],
            'Confidentiality': False,
            'Description': False,
            'Sub information': True,
            'Useful indicators': True,
        },
        'competitive_dialog': {
            'One_lot': '3164941',
            'Multiple': '3164946',
            'Simple': '3164951',
            'Amount': False,
            'Conformity': True,
            'Document type': True,
            'Document type list': ['Технічний опис предмету закупівлі',
                                   'Підтвердження відповідності кваліфікаційним критеріям'],
            'Confidentiality': True,
            'Description': True,
            'Sub information': True,
            'Useful indicators': False,
        },
        'competitive_dialog_eng': {
            'One_lot': '3164954',
            'Multiple': '3164956',
            'Simple': '3164958',
            'Amount': False,
            'Conformity': True,
            'Document type': True,
            'Document type list': ['Технічний опис предмету закупівлі',
                                   'Підтвердження відповідності кваліфікаційним критеріям'],
            'Confidentiality': True,
            'Description': True,
            'Sub information': True,
            'Useful indicators': False,
        },
        'ESCO': {
            'One_lot': '3165194',
            'Multiple': '3165300',
            'Simple': '3165305',
            'Amount': False,
            'Conformity': True,
            'Document type': True,
            'Document type list': ['Технічний опис предмету закупівлі',
                                   'Підтвердження відповідності кваліфікаційним критеріям',
                                   'Документи, що підтверджують відповідність',
                                   'Цінова пропозиція',
                                   'Кошторис'],
            'Confidentiality': True,
            'Description': True,
            'Sub information': True,
            'Useful indicators': True,
        },
    }
    return a[tender_form][tender_sign]


def get_number(amount):
    return int(''.join(re.findall(r'\d+', amount)))


def convert_url(href, IP):
    return str(re.sub('https://smarttender.biz', str(IP), str(href)))


def random_number(a, b):
    a, b = int(a), int(b)
    return str(randint(a, b))


def download_file_and_return_content(url, download_path):
    response = urllib2.urlopen(url)
    file_content = response.read()
    return file_content


def smart_get_time(v=0, accuracy='m'):
    delta = int(v)
    time = datetime.now() + timedelta(days=delta)
    if accuracy == 'm':
        return ('{:%d.%m.%Y %H:%M}'.format(time))
    elif accuracy == 'd':
        return ('{:%d.%m.%Y}'.format(time))


def convert_data_for_web_client(value):
    without_spaces = value.replace(" ", "")
    without_dots = without_spaces.replace(".", "")
    return without_dots.replace(":", "")
