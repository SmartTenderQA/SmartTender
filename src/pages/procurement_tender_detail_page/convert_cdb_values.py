# -*- coding: utf-8 -*-


import re
from iso8601 import parse_date
from datetime import datetime, timedelta
from dateutil.parser import parse
from dateutil.parser import parserinfo


def convert_cdb_values(field, value):
    if 'Period' in field:
        ret = convert_datetime_to_smart_format(value, 'm')
    else:
        ret = value
    return ret


def convert_datetime_to_smart_format(isodate, accuracy='s'):
    iso_dt = parse_date(isodate)
    if accuracy == 's':
        date_string = iso_dt.strftime("%d.%m.%Y %H:%M:%S")
    elif accuracy == 'm':
        date_string = iso_dt.strftime("%d.%m.%Y %H:%M")
    elif accuracy == 'd':
        date_string = iso_dt.strftime("%d.%m.%Y")
    return date_string
