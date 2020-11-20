# cloudlet_parser

A tool that can save debugging time by decoding Cloudlets execution logic and displaying some useful information. Read through the below steps to use the tool. For any queries and feedback email hmallika@akamai.com

Steps to run the tool:

1.After downloading the code zip file, uninstall it.

2.You should see below 4 files after unzipping

 ls -l
total 128
-rwxr-xr-x@  1 hmallika  staff   4192 Nov 19 16:59 cloudlet_parser.sh
-rwxr-xr-x@  1 hmallika  staff   3552 Nov 19 18:50 get_policy_id.py
-rwxr-xr-x   1 hmallika  staff  29552 Nov 19 16:59 nimbus.conf
-rwxr-xr-x   1 hmallika  staff   6699 Nov 19 16:59 nimstat.pl

 3. Check if cloudlet_parser.sh has execute permission if not run this command to give permission : chmod 755 cloudlet_parser.sh
 
 4. Python and Akamai API prerequisites to run the tool:
    4.1 Python 3 with Akamai Edgegrid dependencies installed.
        To Install Akamai modules refer https://developer.akamai.com/api/getting-started  and/or https://github.com/akamai/httpie-edgegrid
    4.2 Valid API credentials (created in Akamai Technologies - Assets account that has multi-account access, edgerc file should have a default section) 

5.  To run this tool you will have to execute this shell script cloudlet_parser.sh with log lines in double quotes.

Example:

$./cloudlet_parser.sh  "log lines"
