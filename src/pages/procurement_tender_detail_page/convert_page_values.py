# -*- coding: utf-8 -*-


import re
import sys

sys.path.append('../../src/')

from service import get_only_numbers


def convert_page_values(field, value):
    global ret
    if 'locality' in field or 'postalCode' in field or 'streetAddress' in field:
        list = re.search(u'(?P<code>\d+), (?P<city>\D+,\s\D+), (?P<street>.+)', value)
        if 'locality' in field:
            ret = list.group('city')
            a = re.search(u'(?P<country>\D+), (?P<city>\D+)', ret)
            city = a.group('city')
            ret = city
        elif 'postalCode' in field:
            ret = list.group('code')
        elif 'streetAddress' in field:
            ret = list.group('street')
    elif 'unit' in field or 'quantity' in field:
        list = re.search(u'(?P<quantity>\d+) (?P<unit>.+)', value)
        if 'unit' in field:
            unit = list.group('unit')
            ret = convert_unit(unit)
        elif 'quantity' in field:
            ret = int(list.group('quantity'))
    elif 'amount' in field:
        ret = re.search(u'(?P<amount>[\d\s.?,]+).*', value).group('amount')
        ret = ret.replace(' ', '')
        ret = ret.replace(',', '.')
        ret = float(ret)
    elif 'agreementDuration' in field:
        ret = get_only_numbers(value)
    else:
        ret = value
    return ret


def convert_unit(value):
    units_map = {
        u'Гектар': u'га',
        u'час': u'квар - час',
        u'Кубический дециметр': u'дм3',
        u'Кубический километр': u'км3',
        u'Погонный метр': u'п.м.',
    }
    if value in units_map:
        result = units_map[value]
    else:
        result = value
    return result

