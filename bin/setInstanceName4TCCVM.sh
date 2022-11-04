#!/bin/bash

cat $1 | while read line
do
	appCode=`echo $line| awk '{print $2}'`;
	ip=`echo $line| awk '{print $3}'`;
	instanceId=`echo $line| awk '{print $1}'`;
	echo set $instanceId  name to $appCode on $ip
	curl 'https://workbench.cloud.tencent.com/cgi/capi?i=cvm/ModifyInstancesAttribute&uin=100027207461&region=ap-beijing' \
  -H 'authority: workbench.cloud.tencent.com' \
  -H 'accept: application/json, text/javascript, */*; q=0.01' \
  -H 'accept-language: en-US,en;q=0.9,zh-CN;q=0.8,zh;q=0.7' \
  -H 'content-type: application/json; charset=UTF-8' \
  -H 'cookie: qcmainCSRFToken=rylWbw9X4P; qcloud_visitId=bcc27c19d29551c67cd4dd90ba690434; _ga=GA1.2.1842767309.1599477513; pgv_pvi=766818304; pgv_si=s1396538368; qcloud_uid=94ff608f1f0c0a15601d5db01086b09f%40devS; __root_domain_v=.tencent.com; _qddaz=QD.930258164825595; language=zh; lastLoginType=wx; _gcl_au=1.1.667749484.1660299662; wework_outh2_state=lawfxf9yotd; mfaRMId=2f72e6d10fa544c58ea0195783c2b684; vcode_sig=h0129132c12fdac426936bbc22630da60e0703ff8cb4841d7c0d7b17a74c6755fac63f32a3b4dad9264; DISTRIBUTION_MODE=1; dbbrain-diag-event=1; dbbrain-sql-favorite=1; pgv_info=ssid=s5251332513; pgv_pvid=2674780628; isQcloudUser=false; qcloud_from=qcloud.bing.seo-1666234706074; opc_xsrf=95f948ecd298008f3c2a19f8b488518d%7C1666605636; projectName=%E5%85%A8%E9%83%A8%E9%A1%B9%E7%9B%AE; uin=o100027207461; tinyid=144115355512182298; loginType=subaccount; subAccountLoginPage=https://cloud.tencent.com/login/subAccount; intl=1; sensorsdata2015jssdkcross=%7B%22distinct_id%22%3A%22100027207461%22%2C%22first_id%22%3A%2294ff608f1f0c0a15601d5db01086b09f%40devS%22%2C%22props%22%3A%7B%22%24latest_traffic_source_type%22%3A%22%E7%9B%B4%E6%8E%A5%E6%B5%81%E9%87%8F%22%2C%22%24latest_search_keyword%22%3A%22%E6%9C%AA%E5%8F%96%E5%88%B0%E5%80%BC_%E7%9B%B4%E6%8E%A5%E6%89%93%E5%BC%80%22%2C%22%24latest_referrer%22%3A%22%22%7D%2C%22%24device_id%22%3A%221746849f95a11-06ffd814126e29-15306250-1764000-1746849f95b355%22%2C%22identities%22%3A%22eyIkaWRlbnRpdHlfY29va2llX2lkIjoiMTgyMTI1MzRlNjc1YTktMDJiMzlhOTU1MGQ2YTItMzU3ZDY3MDItMTc2NDAwMC0xODIxMjUzNGU2OGVkMyIsIiRpZGVudGl0eV9sb2dpbl9pZCI6IjEwMDAyNzIwNzQ2MSJ9%22%2C%22history_login_id%22%3A%7B%22name%22%3A%22%24identity_login_id%22%2C%22value%22%3A%22100027207461%22%7D%7D; lastLoginIdentity=4e3aeb958f3df4f7684848153024d030; refreshSession=1; appid=1313157651; moduleId=1313157651; regionId=8; skey=eW7MmjeKZbD96CH2dOLn*tpBklUWRYKVM0JZbyyLPII_; systemTimeGap=-325; ownerUin=O100026754262G; nick=zhengzj%40100026754262; saas_synced_session=100027207461%7CeW7MmjeKZbD96CH2dOLn*tpBklUWRYKVM0JZbyyLPII_' \
  -H 'origin: https://console.cloud.tencent.com' \
  -H 'referer: https://console.cloud.tencent.com/' \
  -H 'sec-ch-ua: "Chromium";v="106", "Google Chrome";v="106", "Not;A=Brand";v="99"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'sec-ch-ua-platform: "macOS"' \
  -H 'sec-fetch-dest: empty' \
  -H 'sec-fetch-mode: cors' \
  -H 'sec-fetch-site: same-site' \
  -H 'user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/106.0.0.0 Safari/537.36' \
  -H 'x-csrfcode: 714641286' \
  -H 'x-lid: HyvQw-OEj' \
  -H 'x-life: 2136836' \
  -H 'x-referer: https://console.cloud.tencent.com/cvm/instance/index?action=ModifyInstancesAttribute.InstanceName&InstanceId=ins-04hwz2kv&id=ins-04hwz2kv&rid=8&count=50' \
  -H 'x-seqid: 59d45c88-97ca-8a0e-b07c-0b00f1ac2a30' \
  --data-raw '{"serviceType":"cvm","action":"ModifyInstancesAttribute","data":{"Version":"2017-03-12","InstanceIds":["'${instanceId}'"],"InstanceName":"'${appCode}'"},"region":"ap-beijing"}' \
  --compressed
  sleep 1
done


