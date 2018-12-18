def create_cookies_dict_from_string(s):
    ret = dict((k.strip(), v.strip()) for k, v in (item.split('=') for item in s.split(';')))
    return ret
