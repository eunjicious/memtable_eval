DATA_DIR=./memtable_eval/data

#cd $DATA_DIR

bufflist="64 16384"
factors="
	memtable.hit 
	memtable.miss
	l0.hit
	block.cache.hit
	block.cache.miss
"

for buff in $bufflist; do
	for factor in $factors; do
		fname=$factor.$buff.dat
		echo "$fname ...."
		python2.7 ./stat_plot.py $fname
	done
done

factors="
	fillseq
	readrandom
"
for buff in $bufflist; do
	for factor in $factors; do
		fname=$factor.$buff.dat
		echo "$fname ...."
		python2.7 ./perf_plot.py $fname
	done
done


