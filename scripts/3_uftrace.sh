
EXEC_DIR=/home/ubuntu/rocksdb
FUNC1=rocksdb::ArenaWrappedDBIter::SeekToFirst 
FUNC2=rocksdb::ArenaWrappedDBIter::Next
FUNC3=
MAX_TH=9
th=1
mrep="skip_list"
CON=1

buffsize=17179869184 #16GB
#buffsize=67108864
ops=100000

while [[ $th -lt $MAX_TH ]]; do
    fname="$mrep"_"$th".uftrace
    #fname=`echo $FUNC | awk -F: '{print $NF}'`_"$th".uftrace
    #uftrace record -F $FUNC $EXEC_DIR/db_bench --benchmarks="fillseq,readseq" --threads=$th --num=100 && uftrace report
#   uftrace record -Frocksdb::ArenaWrappedDBIter::SeekToFirst $EXEC_DIR/db_bench --benchmarks="fillseq,readseq" --num=100 
    uftrace record -F$FUNC1 -F$FUNC2 $EXEC_DIR/db_bench --benchmarks="fillseq,readseq" --num=$ops --key_size=16 --value_size=100 --write_buffer_size=$buffsize --use_existing_db=0 --allow_concurrent_memtable_write=0 --inplace_update_support=1 --threads=$th --memtablerep=$mrep
	#	--allow_concurrent_memtable_write=$CON \
    uftrace report --no-pager > $fname

    cat $fname

    #cmd=`echo "uftrace record -F$FUNC $EXEC_DIR/db_bench --benchmarks="fillseq,readseq" --num=100 && uftrace report"`
    #$cmd
    th=$((th+th))
done    


