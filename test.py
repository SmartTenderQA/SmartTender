# -*- coding: utf-8 -*-
import re

field = "['item']['amount']"
value = "21 050 417,00"


def convert_page_values(field, value):
    global ret
    if 'city' in field or 'postal code' in field or 'streetAddress' in field:
        list = re.search(u'(?P<code>\d+), (?P<city>\D+,\s\D+), (?P<street>\D+)', value)
        if 'city' in field:
            ret = list.group('city')
            a = ret.split()
            a.reverse()
            ret = "  ".join(a)
            ret = ret.replace(',', '')
        elif 'postal code' in field:
            ret = list.group('code')
        elif 'streetAddress' in field:
            ret = list.group('street')
    elif 'unit' in field or 'quantity' in field:
        list = re.search(u'(?P<quantity>\d+) (?P<unit>\D+)', value)
        if 'unit' in field:
            ret = list.group('unit')
        elif 'quantity' in field:
            ret = list.group('quantity')
    elif 'amount' in field:
        ret = re.search(u'(?P<amount>[\d\s.]+).*', value).group('amount')
        ret = ret.replace(' ', '')
    else:
        ret = value
    return ret



print(convert_page_values(field, value))