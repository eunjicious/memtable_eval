DATA_DIR=./memtable_eval/data

cd $DATA_DIR

bufflist="64 16384"

factors="
	memtable.hit 
	memtable.miss
	l0.hit
"

for buff in $bufflist; do
	for factor in $factors; do
		fname=$factor.$buff.dat
		echo "$fname ...."
		python2.7 ./plot.py $fname
	done
done


