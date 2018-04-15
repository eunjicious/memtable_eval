
#if [[ $# -lt 1 ]]; then
#	echo "buff(MB)"
#fi
#buff=$1

disable_wal=0
ops=100000
mrep="skip_list cuckoo"
#buff=16384
#buff=64
#
#for mr in $mrep; do
#	th=1
#	while [[ $th -lt 17 ]]; do
#		echo "./1_memtable_run.sh $mr $th $disable_wal $ops $buff"
#		./1_memtable_run.sh $mr $th $disable_wal $ops $buff
#		th=$((th+th))
#		sleep 20
#	done
#done
#

function run(){
	buff=$1
  	for mr in $mrep; do
		th=1
		while [[ $th -lt 17 ]]; do
			echo "./1_memtable_run.sh $mr $th $disable_wal $ops $buff"
			fname="$mr"_"$th"_"$disable_wal"_"$ops"_"$buff"
#			cat $fname.perf >> $fname.perf.bak
#			mv $fname.p2f.bak $fname.perf
			./1_memtable_run.sh $mr $th $disable_wal $ops $buff
			th=$((th+th))
#			sleep 20
		done
  	done
}

#run 64
run 16384
