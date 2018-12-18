def create_cookies_dict_from_string(s):
    ret = dict((k.strip(), v.strip()) for k, v in dict((item.split('=') for item in s.split(';'))).iteritems())
    return ret
