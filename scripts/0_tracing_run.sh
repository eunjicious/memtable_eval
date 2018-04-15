EXEC_DIR=/home/ubuntu/rocksdb
DB_DIR=/mnt/rocksdb
WAL_DISABLE=1 # 0: on 1: off
DB_DIR=/tmp

num=5000000
valsize=100
num_threads=1
#buffsize=1073741824
#buffsize=17179869184
buffsize=67108864
workload="fillseq,fillrandom,readseq,readrandom"

#rm -rf /tmp/rocks*
rm -rf $DB_DIR/rocks*

#echo "$EXEC_DIR/rocks_bench --key_size=16 --value_size=$valsize --disable_auto_compactions=1 --write_buffer_size=$buffsize --disable_wal=$WAL_DISABLE --sync=0 --verify_checksum=0 --threads=$num_threads --use_existing_db=0 --allow_concurrent_memtable_write=1 --benchmarks=$workload --memtablerep=$mrep --db=$DB_DIR --num=$num > $res"

if [[ $# < 3 ]]; then
	echo "Usage: ./sh mode num_threads storage"
	echo "e.g: ./sh none 1 nvme"
	exit
fi
#n=1
mon=$1
num_threads=$2
if [[ $3 == "nvme" ]]; then
	DB_DIR=/mnt/rocksdb
else
	DB_DIR=/tmp
fi

echo "cuckoo ....... $num_threads"
mrep="cuckoo"
### cuckoo hash
#res="rocksdb"_"$mrep"_"$num_threads".perf
res="rocksdb"_"$3"_"$mrep"_"$workload"_"$num_threads".perf

if [[ $mon == "perf" ]]; then 
	perf stat -e cache-misses $EXEC_DIR/rocks_bench --key_size=16 --value_size=$valsize --disable_auto_compactions=1 --write_buffer_size=$buffsize --disable_wal=$WAL_DISABLE --sync=0 --verify_checksum=0 --threads=$num_threads --use_existing_db=0 --allow_concurrent_memtable_write=0 --benchmarks=$workload --memtablerep=$mrep --db=$DB_DIR --num=$num > $res
	#perf stat $EXEC_DIR/rocks_bench --key_size=16 --value_size=$valsize --disable_auto_compactions=1 --write_buffer_size=$buffsize --disable_wal=$WAL_DISABLE --sync=0 --verify_checksum=0 --threads=$num_threads --use_existing_db=0 --allow_concurrent_memtable_write=0 --benchmarks=$workload --memtablerep=$mrep --db=$DB_DIR --num=$num > $res
elif [[ $mon == "uftrace" ]]; then
	uftrace record $EXEC_DIR/rocks_bench --key_size=16 --value_size=$valsize --disable_auto_compactions=1 --write_buffer_size=$buffsize --disable_wal=$WAL_DISABLE --sync=0 --verify_checksum=0 --threads=$num_threads --use_existing_db=0 --allow_concurrent_memtable_write=0 --benchmarks=$workload --memtablerep=$mrep --db=$DB_DIR --num=$num > $res
	uftrace report > $res.func
else
	$EXEC_DIR/rocks_bench --key_size=16 --value_size=$valsize --disable_auto_compactions=1 --write_buffer_size=$buffsize --disable_wal=$WAL_DISABLE --sync=0 --verify_checksum=0 --threads=$num_threads --use_existing_db=0 --allow_concurrent_memtable_write=0 --benchmarks=$workload --memtablerep=$mrep --db=$DB_DIR --num=$num --keys_per_prefix=10 --prefix_size=8 > $res
fi
cat $res | grep ops
#


rm -rf /tmp/rocks*
echo "========================="
echo "skip list ...... $num_threads"
mrep="skip_list"
### skip list 
res="rocksdb"_"$mrep"_"$workload"_"$num_threads".perf

if [[ $mon == "perf" ]]; then 
	perf stat -e cache-misses $EXEC_DIR/rocks_bench --key_size=16 --value_size=$valsize --disable_auto_compactions=1 --write_buffer_size=$buffsize --disable_wal=$WAL_DISABLE --sync=0 --verify_checksum=0 --threads=$num_threads --use_existing_db=0 --allow_concurrent_memtable_write=1 --benchmarks=$workload --memtablerep=$mrep --db=$DB_DIR --num=$num > $res
	#perf stat $EXEC_DIR/rocks_bench --key_size=16 --value_size=$valsize --disable_auto_compactions=1 --write_buffer_size=$buffsize --disable_wal=$WAL_DISABLE --sync=0 --verify_checksum=0 --threads=$num_threads --use_existing_db=0 --allow_concurrent_memtable_write=1 --benchmarks=$workload --memtablerep=$mrep --db=$DB_DIR --num=$num > $res
elif [[ $mon == "uftrace" ]]; then
	uftrace record $EXEC_DIR/rocks_bench --key_size=16 --value_size=$valsize --disable_auto_compactions=1 --write_buffer_size=$buffsize --disable_wal=$WAL_DISABLE --sync=0 --verify_checksum=0 --threads=$num_threads --use_existing_db=0 --allow_concurrent_memtable_write=1 --benchmarks=$workload --memtablerep=$mrep --db=$DB_DIR --num=$num > $res
	uftrace report > $res.func
else
	$EXEC_DIR/rocks_bench --key_size=16 --value_size=$valsize --disable_auto_compactions=1 --write_buffer_size=$buffsize --disable_wal=$WAL_DISABLE --sync=0 --verify_checksum=0 --threads=$num_threads --use_existing_db=0 --allow_concurrent_memtable_write=1 --benchmarks=$workload --memtablerep=$mrep --db=$DB_DIR --num=$num  > $res
fi
cat $res | grep ops
#

mv *.perf eunji
mv *.perf.func eunji


