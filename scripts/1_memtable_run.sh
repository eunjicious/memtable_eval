EXEC_DIR=/home/ubuntu/rocksdb
DB_DIR=/mnt/rocksdb
#rm -rf /tmp/rocks*
rm -rf $DB_DIR/rocks*

#echo "$EXEC_DIR/rocks_bench --key_size=16 --value_size=$valsize --disable_auto_compactions=1 --write_buffer_size=$buffsize --disable_wal=$WAL_DISABLE --sync=0 --verify_checksum=0 --threads=$num_threads --use_existing_db=0 --allow_concurrent_memtable_write=1 --benchmarks=$workload --memtablerep=$mrep --db=$DB_DIR --num=$num > $res"

if [[ $# < 5 ]]; then
	echo "Usage: ./sh memtable threads disable_wal ops buffsize(MB)"
	echo "e.g: ./sh cuckoo 1 1 500000 64"
	echo "[memtable] : skip_list, cuckoo, prefix_hash, hash_linked_list"
	echo "[disable_wal] 1: off / 0: on"
	exit
fi

echo "$1 $2 $3 $4 $5"

#_mrep="prefix_hash hash_linkedlist"
_mrep=$1
num_threads=$2
num=$4
WAL_DISABLE=$3 # 0: on 1: off
if [[ $WAL_DISABLE == 1 ]]; then
	ENABLE_PIPELINE=0
	wal="nolog"
else
	ENABLE_PIPELINE=1
	wal="log"
fi

buffsize=`expr $5 \* 1024 \* 1024` ## MB
#buffsize=1073741824
#buffsize=17179869184
#buffsize=67108864
echo "buff = $buffsize"

STATISTICS=1
workload="fillseq,fillrandom,readseq,readrandom"
#workload="fillseq,readrandom"
valsize=100



#####################################

for mrep in $_mrep; do
	ALLOW_CON=0
	if [[ $mrep == "skip_list" ]]; then
		ALLOW_CON=1
	fi

	rm -rf $DB_DIR/*
	echo "=================================="
	echo $mrep ... $num_threads
	#res="$mrep"_www"$num_threads".perf
	res="$1"_"$2"_"$3"_"$4"_"$5".perf
	if [ -e $res ]; then
		mv $res $res.bak
	fi

	echo "$EXEC_DIR/rocks_bench --key_size=16 --value_size=$valsize --disable_auto_compactions=0 --write_buffer_size=$buffsize --disable_wal=$WAL_DISABLE --sync=0 --verify_checksum=0 --threads=$num_threads --use_existing_db=0 --allow_concurrent_memtable_write=0 --benchmarks=$workload --memtablerep=$mrep --db=$DB_DIR --num=$num --keys_per_prefix=10 --prefix_size=8 --enable_pipelined_write=$ENABLE_PIPELINE --statistics=$STATISTICS" > $res

	cat $res
	$EXEC_DIR/rocks_bench \
		--key_size=16 \
		--value_size=$valsize \
		--memtablerep=$mrep \
		--db=$DB_DIR \
		--benchmarks=$workload \
		--write_buffer_size=$buffsize \
		--disable_auto_compactions=0 \
		--sync=0 \
		--verify_checksum=0 \
		--threads=$num_threads \
		--use_existing_db=0 \
#		--allow_concurrent_memtable_write=$ALLOW_CON \
		--num=$num \
		--keys_per_prefix=10 \
		--prefix_size=8 \
		--inplace-update-support=1 \
		#--enable_numa=1 \
		--statistics=$STATISTICS >> $res
#		--enable_pipelined_write=$ENABLE_PIPELINE 
#		--disable_wal=$WAL_DISABLE \
#		--statistics=$STATISTICS \
#		>> $res

	#$EXEC_DIR/rocks_bench --key_size=16 --value_size=$valsize --disable_auto_compactions=1 --write_buffer_size=$buffsize --disable_wal=$WAL_DISABLE --sync=0 --verify_checksum=0 --threads=$num_threads --use_existing_db=0 --allow_concurrent_memtable_write=0 --benchmarks=$workload --memtablerep=$mrep --db=$DB_DIR --num=$num --keys_per_prefix=10 --prefix_size=8 --enable_pipelined_write=$ENABLE_PIPELINE --statistics=$STATISTICS >> $re
	mv $DB_DIR/LOG $res.log

	cat $res

#	cat $res | grep ops | awk '{print "'"$mrep"'", $0}'
	#cat $res | grep ops
done




