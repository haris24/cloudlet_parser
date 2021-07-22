# This script will take log lines as input and parse the nim values to debug cloudlet execution.
# 20-Nov-2020 FIrst version
# hmallika@akamai.com
#
#

echo -e "$1" > loglines_file

log_line=$(grep "nim=" loglines_file)
nim_fileds=$(echo $log_line | awk 'match($0, /nim=[^;]*/) {print substr($0, RSTART+1, RLENGTH-1)}' | cut -c 4-  | tr '\' '\n')
account_id=$(echo $log_line | awk 'match($0, /ACCOUNT-[^@]/) {print substr($0, RSTART+8, RLENGTH+10)}' | cut -d "@" -f1)

echo "------------------------------------"
echo "Debugging Cloudlet(s) execution logic :"
echo "------------------------------------"
cloudlet_executed="None"
matching_akaruleid=""
for i in $nim_fileds; do
	./nimstat.pl $i 2>&1 | tee parser_output_file
	grep "logic-executed" parser_output_file | grep "1" 1>/dev/null
	if [[ $? != "1" ]]; then
			cloudlet_executed=$(grep "Provider" parser_output_file | cut -d ":" -f2 | cut -c 5-)
		matching_akaruleid=$(grep "matching-akaruleid" parser_output_file | cut -d ":" -f2 )
	fi
done
echo "------------------------------------"
echo "Cloudlet executed : "$cloudlet_executed
policy_name=""
er_cloudlet_name=$(echo $log_line | awk 'match($0, /\.ER*/) {print substr($0, RSTART-60, RLENGTH+60)}' | cut -d "\\" -f2 | sed 's/@.*//' | cut -c 3-)
iv_cloudlet_name=$(echo $log_line | awk 'match($0, /\.IV*/) {print substr($0, RSTART-60, RLENGTH+60)}' | cut -d "\\" -f2 | sed 's/@.*//' | cut -c 3-)
fr_cloudlet_name=$(echo $log_line | awk 'match($0, /\.FR*/) {print substr($0, RSTART-60, RLENGTH+60)}' | cut -d "\\" -f2 | sed 's/@.*//' | cut -c 3-)
pr_cloudlet_name=$(echo $log_line | awk 'match($0, /\.CD*/) {print substr($0, RSTART-60, RLENGTH+60)}' | cut -d "\\" -f2 | sed 's/@.*//' | cut -c 3-)
alb_cloudlet_name=$(echo $log_line | awk 'match($0, /\.ALB*/) {print substr($0, RSTART-60, RLENGTH+60)}' | cut -d "\\" -f2 | sed 's/@.*//' | cut -c 3-)
ig_cloudlet_name=$(echo $log_line | awk 'match($0, /\.IG*/) {print substr($0, RSTART-60, RLENGTH+60)}' | cut -d "\\" -f2 | sed 's/@.*//' | cut -c 3-)
api_cloudlet_name=$(echo $log_line | awk 'match($0, /\.AP*/) {print substr($0, RSTART-60, RLENGTH+60)}' | cut -d "\\" -f2 | sed 's/@.*//' | cut -c 3-)
as_cloudlet_name=$(echo $log_line | awk 'match($0, /\.AS*/) {print substr($0, RSTART-60, RLENGTH+60)}' | cut -d "\\" -f2 | sed 's/@.*//' | cut -c 3-)
vp_cloudlet_name=$(echo $log_line | awk 'match($0, /\.VP*/) {print substr($0, RSTART-60, RLENGTH+60)}' | cut -d "\\" -f2 | sed 's/@.*//' | cut -c 3-)

if [[ $cloudlet_executed != "None" && $cloudlet_executed == *"Edge"* ]]; then
	echo "Policy name : "$er_cloudlet_name
	policy_name=$er_cloudlet_name
fi
if [[ $cloudlet_executed != "None" && $cloudlet_executed == *"Forward"* ]]; then
	echo "Policy name : "$fr_cloudlet_name
	policy_name=$fr_cloudlet_name
fi
if [[ $cloudlet_executed != "None" && $cloudlet_executed == *"Phased"* ]]; then
	echo "Policy name : "$pr_cloudlet_name
	policy_name=$pr_cloudlet_name
fi
if [[ $cloudlet_executed != "None" && $cloudlet_executed == *"Visitor"* ]]; then
	echo "Policy name : "$vp_cloudlet_name
	policy_name=$vp_cloudlet_name
fi
if [[ $cloudlet_executed != "None" && $cloudlet_executed == *"API"* ]]; then
	echo "Policy name : "$api_cloudlet_name
	policy_name=$api_cloudlet_name
fi
if [[ $cloudlet_executed != "None" && $cloudlet_executed == *"Audience"* ]]; then
	echo "Policy name : "$as_cloudlet_name
	policy_name=$as_cloudlet_name
fi
if [[ $cloudlet_executed != "None" && $cloudlet_executed == *"Input"* ]]; then
	echo "Policy name : "$iv_cloudlet_name
	policy_name=$iv_cloudlet_name
fi
if [[ $cloudlet_executed != "None" && $cloudlet_executed == *"Application"* ]]; then
	echo "Policy name : "$alb_cloudlet_name
	policy_name=$alb_cloudlet_name
fi
if [[ $matching_akaruleid != "" ]]; then
	#statements
	echo "Executed rule id : "$matching_akaruleid
fi
echo "Account ID : "$account_id


if [[ $policy_name != "" && $matching_akaruleid != ""  && $account_id != "" ]]; then
	echo "Getting executed rule description for reference.."
	echo "This will fetch data only if you have valid API credentials (created in Akamai Technologies - Assets account that has multi-account access) and your edgerc file has a default section"

	python3 get_policy_id.py  --a $account_id --p $policy_name --r $matching_akaruleid
fi

rm ./parser_output_file
rm ./loglines_file
echo "------------------------------------"
