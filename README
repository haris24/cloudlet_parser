# cloudlet_parser

A tool that can save debugging time by decoding Cloudlets execution logic and displaying some useful information. Read through the below steps to use the tool. For any queries and feedback email hmallika@akamai.com

Steps to run the tool:

1.After downloading the code zip file, unzip it.

2.You should see below 4 files after unzipping

 ls -l
total 128
-rwxr-xr-x@  1 hmallika  staff   4192 Nov 19 16:59 cloudlet_parser.sh
-rwxr-xr-x@  1 hmallika  staff   3552 Nov 19 18:50 get_policy_id.py
-rwxr-xr-x   1 hmallika  staff  29552 Nov 19 16:59 nimbus.conf
-rwxr-xr-x   1 hmallika  staff   6699 Nov 19 16:59 nimstat.pl

3.Give execute permission to scripts cloudlet_parser.sh and nimstat.pl by running below commands in terminal 
    chmod 755 cloudlet_parser.sh
    chmod 755 nimstat.pl
 
4. Python and Akamai API prerequisites to run the tool:
    4.1 Python 3 with Akamai Edgegrid dependencies installed.
        To Install Akamai modules refer https://developer.akamai.com/api/getting-started  and/or https://github.com/akamai/httpie-edgegrid
    4.2 Valid API credentials (created in Akamai Technologies - Assets account that has multi-account access, edgerc file should have a default section) 

5. To run this tool you will have to execute this  script cloudlet_parser.sh with log lines in double quotes.

Example:

$./cloudlet_parser.sh  "log lines"

Below is real time run with output:

% ./cloudlet_parser.sh "23.195.252.111 r 1605755795.153 12 27 0 3 0 0 26403 23.79.238.33 GET /D/16976/629695/000/www.abc.com/credit-cards/knowledge-center/abc-articles/abc.action?ID=common-credit-card-terms-decoded 301 - k - www.abc.com - - Mozilla/5.0-Akamai-Test-1605755795 - TLSv1.2 1 - 736 - - a276a926 0 3895 27e32515 16976.x - - rp - - - - - 1160 638 28295 - - - fu=301;k=0;req2=;ip2= oSK 643 r7f458eb530b0.-1.n.g 2320 sgrD8 - 5ed1f940 - - - - 23.79.238.33 5760 NCWP_106196|3900000:3900004:3900031| - - www.abc.com - h //waf@ra/2091/1/0//#1 - - cca=bbr;api=API_624157;mxc=//waf@ra/1/d/23.79.238.33;mtse=g|4294967295;webprod=Alta;pcf=//a1@hdo/HPKUBEK\//a2@hdo/BIGHE\//@tcp/24400FAF0205B4481307+0B\//@tls/eeb31457ad64ff16;waf=|1,1,1|2(monitor),2(monitor),2(monitor)|||;wre=108%7c;mo=rpt:11;sn=16976||16976|;aid=162133;tap=//ACCOUNT-F-AC-200209@0.RPD.0/i/0/-#0,44015,0\//ACCOUNT-F-AC-200209-624157@0.RPD.1/h/1/-#143830,0,5649\//datastream_162133@162133.DS/h/1/-#52438,0,472\//Marketing_PROD_43464_NGAredirects@162133.ER/h/1/-#615952,0,22935;nimb=//0/1/1/1/;nim=//0//1/1/f6a47dae7a930fe8/-/#615951;rep2=//cid/23.79.238.33\//ctx/NOSCR#0\//dbv/2;ecc=2;pin=http|-;pfs=c;ssl=300c030::415;alpn=http/1.1;netp=;aidv=116;fp=253;cpu=//ctx@waf/3330/5565\//prod@adt/29\//prod@aib/39\//prod@bm/948\//prod@cr/5\//prod@ksd/1444\//prod@wib/12;pgma=33590016;tff=8007;mle=10373 - - - 15265:198833:0:801 L3:L3:s:L3:: 1 vcd=10640;mas=4198:::::::157:595:821:;masc=::81:;ett=3;cpu=//thd@phtm4/9014\//thd@ssl/855;mle=10373 - - - - - 898 5257 - -
23.195.252.111 f 1605755800.187 0 1 0 25 0 0 114 23.67.152.101 127.0.0.1 POST /D/16382/670831/000/beacons.ddc.akadns.net/akamillbridge/datastream_dlr 200 - - TLSv1.2 oaDdx 10 - - a276a1ac beacons.ddc.akadns.net 717 1403 0 /D/16382/670831/000/beacons.ddc.akadns.net/akamillbridge/datastream_dlr 27e32515 - - 116 116 - - - - - - 0 210008979;0;o;8819;-;- - r7f458eb508c0.-1.n.g - - 348 5ed1f940 - 0 0 - - - - drl=1;aid=440131;pin=http|-;ssl=300003d:::;aidv=5;netp=;ccl=u;webprod=Site_Accel;rmap=x - 16976.UNDEFINED 503 - L3:L3::: -"


------------------------------------
Debugging Cloudlet(s) execution logic :
------------------------------------
Parsing value                 : //0//1/1/f6a47dae7a930fe8/-/#615951
Provider                      : 0 - Edge Redirector
cloudlet-off-reason           : empty ( Cloudlet was "on" )
do-cloudlet                   : 1 ( on )
logic-executed                : 1 ( yes )
matching-akaruleid            : f6a47dae7a930fe8
policy-match-error            : -
policy-selector-cost          : #615951

------------------------------------
Cloudlet executed :  Edge Redirector
Policy name : Marketing_PROD_43464_NGAredirects
Executed rule id :  f6a47dae7a930fe8
Account ID : F-AC-200209
Getting executed rule description for reference..
This will fetch data only if you have valid API credentials (created in Akamai Technologies - Assets account that has multi-account access) and your edgerc file has a default section
Marketing_PROD_43464_NGAredirects v7 on prod:
{
    "akaRuleId": "f6a47dae7a930fe8",
    "end": 0,
    "id": 0,
    "location": "/cloudlets/api/v2/policies/128111/versions/7/rules/f6a47dae7a930fe8",
    "matchURL": null,
    "matches": [
        {
            "caseSensitive": false,
            "matchOperator": "equals",
            "matchType": "path",
            "matchValue": "/credit-cards/knowledge-center/abc-articles/abc.action",
            "negate": false
        },
        {
            "caseSensitive": false,
            "matchOperator": "equals",
            "matchType": "query",
            "matchValue": "ID=financial-habits-excellent-credit common-credit-card-terms-decoded build-credit-with-a-secured-credit-card secured-vs-unsecured-credit-cards credit-card-faqs-and-tips 5-questions-to-ask-before-getting-first-credit-card how-to-overcome-credit-card-fear credit-card-terms smart-credit-card-tips build-credit-new-residents building-credit-after-college inside-a-credit-report how-to-check-a-credit-report how-to-help-build-credit how-to-build-credit applying-for-a-credit-card",
            "negate": false
        },
        {
            "caseSensitive": false,
            "matchOperator": "equals",
            "matchType": "regex",
            "matchValue": "https:\\/\\/(?:[^\\?]+)\\?ID=([^&]+)&?(.*)$",
            "negate": false
        }
    ],
    "name": "Carry over QS's ABC-3364-1",
    "redirectURL": "https://www.abc.com/credit-cards/understanding-credit-cards/\\1",
    "start": 0,
    "statusCode": 301,
    "type": "erMatchRule",
    "useIncomingQueryString": false
}
------------------------------------



Notes:

If you see errors like below, that means Python script is having problems accessing Akamai edgegrid modules, check step 4.1 above and try again.


Traceback (most recent call last):
  File "/Users/hmallika/Downloads/cloudlet_parser-main/get_policy_id.py", line 8, in <module>
    from config import EdgeGridConfig
ModuleNotFoundError: No module named 'config'
