#!/usr/bin/env python
# -*- coding: utf-8 -*-
# ==============
#      Main script file
# ==============
import sys
import re
import urllib2
import requests

from iso8601 import parse_date
from datetime import datetime, timedelta
from dateutil.parser import parse
from dateutil.parser import parserinfo
from glob import glob
import os
import operator
import uuid
import hashlib
import json


reload(sys)
sys.setdefaultencoding('utf-8')


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
        'above_threshold_ua_defense': {
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
        'above_threshold_ua_defense': u'Переговорна процедура для потреб оборони',
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
    return str(re.sub('https://smarttender.biz/', str(IP), str(href)))


def download_file_and_return_content(url):
    response = urllib2.urlopen(url)
    file_content = response.read()
    return file_content


def download_file_to_my_path(url, path):
    r = requests.get(url)
    with open(path, 'wb') as f:
        f.write(r.content)


def get_only_numbers(value):
    date = re.sub(r"\D", "", value)
    return date


def smart_get_time(v=0, accuracy='m'):
    delta = int(v)
    time = datetime.now() + timedelta(days=delta)
    if accuracy == 'm':
        return ('{:%d.%m.%Y %H:%M}'.format(time))
    elif accuracy == 's':
        return ('{:%d.%m.%Y %H:%M:%S}'.format(time))
    elif accuracy == 'd':
        return ('{:%d.%m.%Y}'.format(time))
    elif accuracy == 'h':
        return ('{:%H:%M}'.format(time))


def get_time_now_with_deviation(v, deviation):
    delta = int(v)
    if deviation == 'days':
        time = datetime.now() + timedelta(days=delta)
    elif deviation == 'minutes':
        time = datetime.now() + timedelta(minutes=delta)
    return ('{:%d.%m.%Y %H:%M}'.format(time))


def get_formated_time_with_delta(delta, deviation='days', accuracy='s'):
	time = get_time_with_delta(delta, deviation)
	if accuracy == 'm':
		return ('{:%d.%m.%Y %H:%M}'.format(time))
	elif accuracy == 's':
		return ('{:%d.%m.%Y %H:%M:%S}'.format(time))
	elif accuracy == 'd':
		return ('{:%d.%m.%Y}'.format(time))


def get_time_with_delta(delta, deviation):
	days = int(delta)
	weekends_url = 'http://standards.openprocurement.org/calendar/workdays-off.json'
	workdays_url = 'http://standards.openprocurement.org/calendar/weekends-on.json'
	response = urllib2.urlopen(weekends_url)
	weekends = json.load(response)
	response = urllib2.urlopen(workdays_url)
	workdays = json.load(response)
	if deviation == 'days':
		while True:
			weekends_count = 0
			for i in range(0, days + 1):
				tmp = datetime.now() + timedelta(days=i)
				if tmp.weekday() > 4 or '{:%Y-%m-%d}'.format(tmp) in weekends and not '{:%Y-%m-%d}'.format(tmp) in workdays:
					weekends_count += 1
			if days - weekends_count == int(delta):
				break
			else:
				days += 1
		return datetime.now() + timedelta(days=days)
	elif deviation == 'minutes':
		return datetime.now() + timedelta(minutes=days)


def no_weekend(date):
    date = parse(date, parserinfo(True, False))
    if date.weekday() == 5 or date.weekday() == 6:
        date = date + timedelta(days=2)
    return ('{:%d.%m.%Y}'.format(date))


def add_day_for_date(date):
    date = parse(date, parserinfo(True, False))
    date = date + timedelta(days=1)
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


def wait_to_date(date_stamp, day_first=True):
    date = parse(date_stamp, dayfirst=day_first)
    now = datetime.now()
    wait_seconds = (date - now).total_seconds()
    return wait_seconds


def convert_date_from_cdb(date):
    time = (parse(date)).replace(tzinfo=None)
    time = (time.strftime('%Y-%m-%d %H:%M:%S'))
    return time


def clear_test_output():
    for filename in glob("test_output/*.pdf"):
        os.remove(filename)

    for filename in glob("test_output/*.png"):
        os.remove(filename)

    for filename in glob("test_output/*.doc"):
        os.remove(filename)


def get_tender_href_for_commercial_owner(value):
    list = re.search('.*(?P<href>http.+)(?P<ticket>\?ticket=.+)\'.*', value)
    href = list.group('href')
    ticket = list.group('ticket')
    return href, ticket


def get_some_uuid():
    value = str(uuid.uuid4())
    return value


def get_checksum_md5(file):
    hasher = hashlib.md5()
    with open(file, 'rb') as afile:
        buf = afile.read()
        hasher.update(buf)
        return hasher.hexdigest()
