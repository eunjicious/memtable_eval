

storage="nvme"
for st in $storage; do
	th=1
	echo "" > all.rslt
	while [[ $th -lt 17 ]]; do
		echo "./0_run.sh none $th $st"
		#echo "./0_run.sh none $th $st" >> all.rslt
		./0_run.sh none $th $st >> all.rslt
		th=$((th+th))
		sleep 20
	done
	mv all.rslt all_"$st"_16G_nolog.rslt
done
