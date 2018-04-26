DATA_DIR=./memtable_eval/data
DATA_DIR=.

#if [[ $# -lt 1 ]]; then
#	echo "buff(MB)"
#fi
#buff=$1

disable_wal=0
ops=5000000
mrep="skip_list cuckoo prefixhash  hash_linkedlist"
bufflist="64 16384"
factors="
	memtable.hit 
	memtable.miss
	l0.hit
	l1.hit
	block.cache.hit
	block.cache.miss
"


echo "memtable.hit"

function get_stat() {
	factor=$1

	for buff in $bufflist; do
		echo "========= $factor $buff ==========="
		data_file=$factor.$buff.dat
		echo "# line thread mrep count" > $data_file
		#echo "# line thread mrep count" > "memtable.hit.$buff.dat"
		touch tmp
		th=1
		line=1
		while [[ $th -lt 17 ]]; do
	  		for mr in $mrep; do
				prefix="$mr"_"$th"_"$disable_wal"_"$ops"_"$buff"
				fname=$prefix.perf
				if [ ! -e $fname ]; then
					echo "$fname is not found"
					#th=$((th+th))
					continue
				fi
				count=`cat $fname | grep $factor | grep -v sim | awk '{print $NF}'`
				#count=`cat $fname | grep "memtable.hit" | awk '{print $NF}'`
				#cat $fname | grep -v "Percentile" | grep "rocksdb" | awk -F: '$2!=0 {print $0}'
				#echo "./1_memtable_run.sh $mr $th $disable_wal $ops $buff"
	#			./1_memtable_run.sh $mr $th $disable_wal $ops $buff
				echo $line $th $mr $count >> tmp
				line=$((line+1))
	#			sleep 5
			done	
			th=$((th+th))
			line=$((line+1))
	  	done
		sort -n tmp >> $data_file
		rm tmp
		cat $data_file
#		mv $data_file $DATA_DIR
	done
}

######
for factor in $factors; do
	get_stat $factor		
done
