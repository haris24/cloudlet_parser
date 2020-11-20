#!/usr/bin/python3
#Importing the libraries
import requests
import json
from akamai.edgegrid import EdgeGridAuth
from urllib.parse import urljoin
import re
from config import EdgeGridConfig
import sys
from http_calls import EdgeGridHttpCaller
import re
import argparse

section_name = "default"
config = EdgeGridConfig({"p":True,"r":True,"a":True},section_name)
s = requests.Session()
debug = False
verbose = False
s.auth = EdgeGridAuth(
            client_token=config.client_token,
            client_secret=config.client_secret,
            access_token=config.access_token
)
if hasattr(config, "debug") and config.debug:
  debug = True

if hasattr(config, "verbose") and config.verbose:
  verbose = True

# Initialize parser
parser = argparse.ArgumentParser()
parser.add_argument("-p", "--p", help = "")
parser.add_argument("-r", "--r", help = "")
parser.add_argument("-a", "--a", help = "")
# Read arguments from command line
args = parser.parse_args()

if args.p:
    policy_name = args.p
if args.r:
    executed_rule_id = args.r
if args.a:
    account_name = args.a

baseurl = '%s://%s/' % ('https', config.host)
httpCaller = EdgeGridHttpCaller(s, debug, verbose, baseurl)

def print_rule_desc(p,r,a):
    ct_headers = {"content-type": "application/json"}
    policy_name = p
    executed_rule_id = r
    account_key = a
    apiurl = '/cloudlets/api/v2/policies?accountSwitchKey=' + account_key
    query_result_get=s.get(urljoin(baseurl,'%s' % apiurl ))
    if (query_result_get.status_code == 200):
        query_result_get_json = json.loads(query_result_get.text)
        #print(query_result_get_json)
        for i in query_result_get_json:
            #print(i["name"])
            if i["name"] == policy_name:
                #print(i["location"])
                location = i["location"]
                #print(i["activations"])
                for j in i["activations"]:
                    if j["policyInfo"]["status"] == "active" and j["network"] == ("prod") or j["network"] == ("staging"):
                        #print(j["network"])
                        #print(j["policyInfo"]["version"])
                        version = str(j["policyInfo"]["version"])
                        apiurl_get_rule = location + '/versions/'+ version +'/rules/'+ executed_rule_id + '?accountSwitchKey=' + account_key
                        query_result_get_rule=s.get(urljoin(baseurl,'%s' % apiurl_get_rule ))
                        if (query_result_get_rule.status_code == 200):
                            parsed_result = json.loads(query_result_get_rule.text)
                            network = j["network"]
                            print("\033[1m"+policy_name+' v'+version+' on '+network+':'+"\033[0m")
                            print(json.dumps(parsed_result, indent=4, sort_keys=True))
                        break
    else:
        print("Cannot access API using account switch key :" + account_key)

apiurl_acountkey = '/identity-management/v1/open-identities/p4hynenxmdknoyyn/account-switch-keys?search='+ account_name
query_result_apiurl_acountkey = s.get(urljoin(baseurl,'%s' % apiurl_acountkey ))
if (query_result_apiurl_acountkey.status_code == 200):
    query_result_apiurl_acountkey_json = json.loads(query_result_apiurl_acountkey.text)
    if len(query_result_apiurl_acountkey_json) == 1:
        account_key = query_result_apiurl_acountkey_json[0]["accountSwitchKey"]
        print_rule_desc(policy_name,executed_rule_id,account_key)
    else:
        print("Cannot search account switch key. \n")
