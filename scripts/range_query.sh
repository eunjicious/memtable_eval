num=10000
valsize=100
num_threads=1
num_nexts_per_seek=10
buffsize=1073741824
#buffsize=64
workload="fillrandom,seekrandom"
#workload="fillrandom"

#echo "./rocks_bench --key_size=16 --value_size=$valsize --disable_auto_compactions=1 --write_buffer_size=$buffsize --disable_wal=1 --sync=0 --verify_checksum=0 --threads=$num_threads --use_existing_db=0 --allow_concurrent_memtable_write=1 --benchmarks=$workload --memtablerep=$mrep --num=$num > $res"



function run() {
	echo $1 $2 $3

	mrep=$1
	prefix=$2
	suffix=$3
	con=1
	if [[ $mrep != "skiplist" ]]; then
		con=0
	fi


	rslt_file="rocksdb"_"$mrep"_"$workload"_"$num_threads".perf

	echo "$mrep ....... $num_threads"
	
	$prefix ./rocks_bench --benchmarks=$workload \
		--num=$num  \
		--memtablerep=$mrep \
		--allow_concurrent_memtable_write=0 \
		--disable_auto_compactions=1 --write_buffer_size=$buffsize --disable_wal=1 --sync=0 --verify_checksum=0 \
		--use_existing_db=0 \
		--threads=$num_threads \
		--seek_nexts=$num_nexts_per_seek \

		#--reverse_iterator= \
		#--seed=$(date + %s) \
		#--key_size=16 
		#--value_size=$valsize 
		> $rslt_file
	$suffix > $rslt_file.func
}



if [[ $1 == "perf" ]]; then 
	_prefix="perf stat "
elif [[ $1 == "uftrace" ]]; then
	_prefix="uftrace record"
	_suffix="uftrace report"
fi
echo $_prefix $_suffix
run "cuckoo" $_prefix $_suffix
run "skiplist" $_prefix $_suffix
	

