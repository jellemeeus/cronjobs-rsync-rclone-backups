#!/usr/bin/python3
import sys
import re
import json

files = sys.argv[1:]

with open('regex_sub.json', 'r') as f:
    regex_sub = json.load(f)
    print(regex_sub)

for file in files:
    with open(file, 'r') as f:
        content = ''
        lines = f.readlines()
        for line in lines:
            for regex,sub in regex_sub.items():
                line = re.sub(regex, sub, line)
            content += line
    with open(file, 'w') as f:
        f.write(content)
        print('processed: '+file)
