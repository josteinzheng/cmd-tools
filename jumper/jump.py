#!/usr/bin/env python3
#coding=utf-8
import os
import json
import sys
import getpass
import re

def tipPrint(msg):
    print('>>>>>>>>   ' + msg)

host = 'jump.imrfresh.net'
port = '2222'
username='zhengzj'
os.environ['host'] = host
os.environ['port'] = port
os.environ['searchStr'] = 'p' 
if len(sys.argv) > 1:
    username = sys.argv[1];
if len(sys.argv) > 2:
    os.environ['searchStr'] = sys.argv[2]
os.environ['username'] = username

shell = sys.path[0] + '/xjump.sh '
shell += " ".join(sys.argv[1:])

os.system(shell)
