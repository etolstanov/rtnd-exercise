#!/bin/env/python3

import os
import sys

'''
Class used to parse an url with a specific format and extract
positional arguments.
'''
class UrlParser(object):
    def __init__(self, url_format, url_instance):
        self.url_format = url_format
        self.url_instance = url_instance        
        self.keys = {}

        url = self.url_instance
        #if we have a querystring, split it and analyze it later
        if '?' in self.url_instance:            
            self.querystring = self.url_instance.split('?')[1]
            url = self.url_instance.split('?')[0]

        self.parse_format(url)

    def parse_format(self, url):        
        url_i = url.split('/')
        url_f = self.url_format.split('/')

        #both collections must have the same cardinality, if not the input is invalid
        if len(url_i) != len(url_f):
            raise Exception('url_format does not match url_instance')

        ix = 0
        for element in url_f:
            if element.startswith(':'):
                self.keys[element[1:]] = url_i[ix] #add the key/value pair to the dictionary without the ':'
            ix += 1

        self.parse_querystring()

    def parse_querystring(self):
        #now we check if there was a querystring, split it and add all the values to the dictionary
        if self.querystring:
            for kv in self.querystring.split('&'):
                e = kv.split('=')
                self.keys[e[0]] = e[1]

    def __str__(self):
        import json

        #why json? to give the dictionary a 'pretty' output
        return json.dumps(self.keys, indent=4, sort_keys=False)

if __name__ == '__main__':
    try:
        if not 'URL_FORMAT' in os.environ or not 'URL_INSTANCE' in os.environ:
            raise Exception('URL_FORMAT/URL_INSTANCE are both mandatory')
            
        u = UrlParser(url_format=os.environ['URL_FORMAT'],
                url_instance=os.environ['URL_INSTANCE'])
        print(u)
    except Exception as e:
        print(f'There was an error while parsing the url -> {str(e)}')
        sys.exit(1)
