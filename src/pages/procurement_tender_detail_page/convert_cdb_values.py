# -*- coding: utf-8 -*-


import re
import sys

sys.path.append('../../src/')

from service import convert_datetime_to_smart_format


def convert_cdb_values(field, value):
    if 'Period' in field:
        ret = convert_datetime_to_smart_format(value, 'm')
    else:
        ret = value
    ret = convert_result(ret)
    return ret


def convert_result(value):
    if re.match(u'^\d+[.]?\d+\s+\d+[.]?\d*$', str(value)):
        value = str(value).replace(" ", "")
        return float(value)
    return str(value).decode("utf-8")