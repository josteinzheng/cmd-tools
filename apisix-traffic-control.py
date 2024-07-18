#!/usr/bin/env python
# -*- coding: UTF-8 -*-

from pickle import FALSE
import requests
import json
import sys
import socket

reload(sys)
sys.setdefaultencoding('utf-8')
#超时时间
socket.setdefaulttimeout(10)

"""
offline 摘流量 online 挂流量
查询要摘流量的虚拟机ip
查询所有upstreams
遍历upstream看虚拟机ip是否配置在某一个upstream中
如果查到upstream，就尝试摘挂流量（设置权重为0/1)
"""

class Dict(dict):
    __setattr__ = dict.__setitem__
    __getattr__ = dict.__getitem__

def dictToObject(dictObj):
    if isinstance(dictObj, list):
        inst = []
        for item in dictObj:
            inst.append(dictToObject(item))
        return inst
    elif not isinstance(dictObj, dict):
            return dictObj
    inst = Dict()
    for k,v in dictObj.items():
        inst[k] = dictToObject(v)
    return inst

def tipPrint(msg):
    print('>>>>>>>>   ' + msg)

def exitOnFail(resp, msg):
  if resp.status_code >= 300:
    print('status_code:' + str(resp.status_code))
    print(resp.json())
    tipPrint(msg)
    sys.exit(1)

APISIX_TOKEN = "1d15a89887dba290e174f3c7e0a0adb0"
APISIX_HEADER = {"X-API-KEY": APISIX_TOKEN}
APISIX_UPSTREAM_URL = "http://apisix-0.imrfresh.net/apisix/admin/upstreams/"

def allUpstreamInfos():
  resp = requests.get(APISIX_UPSTREAM_URL, headers=APISIX_HEADER)
  exitOnFail(resp, 'fail to query upstream info')
  resp = json.loads(resp.text)
  return resp['node']['nodes'];

def isUpstreamContainsIp(upstreamNode, ip):
  if hasattr(upstreamNode['value']['nodes'], 'items'):
    for k,v in upstreamNode['value']['nodes'].items():
      if k.startswith(ip + ':'):
        return True
  else:
    for node in upstreamNode['value']['nodes']:
      if node['host'] == ip:
        return True
  return False


def findMatchUpstream(ip):
  upstreamNodes = allUpstreamInfos()
  for upstreamNode in upstreamNodes:
    if isUpstreamContainsIp(upstreamNode, ip):
      return upstreamNode
  return None


def upstreamIdFromNodeKey(nodeKey):
  return nodeKey[nodeKey.rindex('/')+1:]

def trafficControl(upstreamNode, operation, ip):
  weight = 1 if 'online' == operation else 0
  upstreamId = upstreamIdFromNodeKey(upstreamNode['key'])

  nodes = {}
  if hasattr(upstreamNode['value']['nodes'], 'items'):
    for k,v in upstreamNode['value']['nodes'].items():
      if k.startswith(ip + ':'):
        nodes[k] = weight
      else:
        nodes[k] = v
  else:
    for node in upstreamNode['value']['nodes']:
      if node['host'] == ip:
        nodes[node['host'] + ':' + str(node['port'])] = weight
      else:
        nodes[node['host'] + ':' + str(node['port'])] = node['weight']
  data = {"nodes": nodes}
  resp = requests.patch(APISIX_UPSTREAM_URL + upstreamId, json=data, headers=APISIX_HEADER)
  exitOnFail(resp, '摘挂流量失败,请手动修复-> ' + 'http://apisix-dashboard.imrfresh.net/upstream/' + str(upstreamId) + '/edit')


def onlineCVM(upstreamNode, ip):
  trafficControl(upstreamNode, 'online', ip)

def offlineCVM(upstreamNode, ip):
  trafficControl(upstreamNode, 'offline', ip)

if len(sys.argv) < 1:
  tipPrint('未传操作, e.g. traffic-control.py offline')
  sys.exit(1)
operation = sys.argv[1]
ip = socket.gethostbyname(socket.gethostname())
tipPrint('local ip address: ' + ip)
nodes = allUpstreamInfos()
node = findMatchUpstream(ip)
tipPrint(json.dumps(node))
if node is None:
  tipPrint('未找到网关配置')
  sys.exit(0)
else:
  if 'offline' == operation:
    offlineCVM(node, ip)
  else:
    onlineCVM(node, ip)
sys.exit(0)
