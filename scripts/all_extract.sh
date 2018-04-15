

if [[ $# -lt 3 ]]; then 
	echo "./.sh cuckoo 16G nolog"
	exit
fi

buff=$2
log=$3
workloads="fillseq fillrand readseq readrand"

if [[ $log == "log" ]]; then
	cline=1
	sline=0
else
	cline=0
	sline=1
fi

for w in $workloads; do
	if [[ $1 == "cuckoo" ]]; then
		echo "$w threads cuckoo"
		cat all_"$buff"_"$log".rslt | grep -v "rocks" | grep $w | awk 'BEGIN {th = 1} NR%2=='"${cline}"' {print "cuckoo-'"${buff}"'", th, $5; th*=2;}'
		#cat all_"$buff"_"$log".rslt | grep -v "rocks" | grep $w | awk 'NR%2==1 {th = 1;} BEGIN {print "cuckoo-'"${buff}"'", int(NR/2)+1, $5}'
	else
		echo "$w threads skip"
		cat all_"$buff"_"$log".rslt | grep -v "rocks" | grep $w | awk 'BEGIN {th = 1} NR%2=='"${sline}"' {print "skiplist-'"${buff}"'", th, $5; th*=2;}'
		#cat all_"$buff"_"$log".rslt | grep -v "rocks" | grep $w | awk 'NR%2==0 {print "skiplist-'"${buff}"'",int(NR/2)+NR%2, $5}'
	fi
done
