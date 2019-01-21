import re


def create_cookies_dict_from_string(s):
    # ret = dict((k.strip(), v.strip()) for k, v in (item.split('=') for item in s.split(';')))
    cookie_list = s.split(';')
    cookie_dict = {}
    for item in cookie_list:
        result = re.search('(?P<key>.*)=(?P<value>.*)', item)
        key = result.group('key')
        value = result.group('value')
        cookie_dict.update({key: value})
    return cookie_dict
