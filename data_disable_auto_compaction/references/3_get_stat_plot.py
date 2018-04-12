#! /usr/bin/python2.7
import os # get file list
from zplot import *
import glob # file matching
import re # regular expression
import math

_benchpath = os.path.dirname(os.path.abspath(__file__))
#_Memtable = ('filestore','bluestore','buddystore')
_Memtable = ('skip_list', 'cuckoo')
#_Memtable = ('filestore', 'buddystore')
#_IOsize = ('4096','8192','16384','32768','65536','131072','262144','524288','1048576',)
#_cIOsize = ('4K','8K','16K','32K','64K','128K','256K','512K','1M',)
_Threads = ('1','2','4','8','16',)
#_header = '# line iosize store bandwidth\n'
_linedivide = '0\t0\t0\n'
#_extractpath = os.path.join(_benchpath, '3_rados.perf')

_data_file=sys.argv[1]
_title = 'rocksdb'
_type = 'eps'
#_benchdatadir = '3_rados'
_div = 5

def get_ymax(coll_list, t):
	ymax = 0

	for c in coll_list:
		ymax = ymax if t.getmax(c) < ymax else t.getmax(c)

	ymax = ymax + ymax * 0.1

	round_ymax = 0
	round_scale = 10 if ymax < 100 else 100

	while round_ymax < ymax:
		round_ymax += round_scale

	print(round_ymax)

	return round_ymax

#def extract_perf():
#	idx = 1
#	sidx = 0
#
#	fw = open(_extractpath, 'w+')
#	fw.write(_header)
#	for x in _IOsize:
#		for y in _Memtable :
#			readpath = os.path.join(_benchpath,
#									_benchdatadir,
#									y + '_rados_th16_' + x + '_' + x + '.perf')
#
#			print 'Bandwidth extracted from ' + readpath + ' ......'
#			# Is there benchmark result ?
#			if os.path.exists(readpath):
#				fr = open(readpath, 'r')
#				for line in fr:
#					line.strip('\n')
#					data = line.split(":")
#					#if data[0] == "Max bandwidth (MB/sec)":
#					if data[0] == "Bandwidth (MB/sec)":
#						bandwidth = data[1].rstrip('\n').strip(' ')
#						gdata = str(idx) + ' ' + _cIOsize[sidx] + ' ' + y + ' ' + bandwidth + '\n'
#						idx = idx + 1
#						fw.write(gdata)
#						continue
#				fr.close()
#			# There is no result... so making a fake data.
##            else:
##                gdata = str(idx) + ' ' + _cIOsize[sidx] + ' ' + y + ' ' + str(float(bandwidth)+(10 * (idx % 4))) + '\n'
##                print gdata
##                fw.write(gdata)
##                idx += 1
#		# Make a split line.
#		#fw.write(str(idx) + ' ' + _linedivide)
#		idx+=1
#		#idx += _Memtable.__len__()+1
#		sidx += 1
#
#	fw.close();
#	print 'Data extraction completed to ' + _extractpath + ' ......'

def plot():

	t = table(file=datafile,
			  separator=' ')

	options = [('skip_list', 'black', 'dline2', 'black', 0.55, 2.5),
#			   ('bluestore', confname[1], 'red', 'utriangle', 'black', 2, 2),
#			   ('buddystorepw', confname[2], 'orange', 'hline', 'black', 0.55, 2.4),
			   ('cuckoo', 'darkcyan', 'dline1', 'black', 0.55, 3),
			   ]

	c = canvas(type, title=data_file, dimensions=['3in','1.85in'])

	ymax = get_ymax(['bandwidth'],t)

	d = drawable(c,
				 xrange=[0,t.getmax('line')+1],
				 yrange=[0,ymax],
				 # coord=[55,30],
				 # dimensions=['1.5in','1.1in'],
				 )

	w = 'store="%s"' % "bluestore"
	xym = []

	for x, y, z in t.query(select='store,line,iosize', where=w):
		y = str(float(y) + 0.5)
		xym.append((z, y))

	axis(d,
		 style='box',
		 linewidth=0.65,
		 xmanual=xym,
		 yauto=[0,ymax,ymax/_div],
		 doxmajortics=False,
		 ytitle='Throughput (MB/s)',
		 #ytitleshift=[10,0],
		 #title='Performance',
		 #xtitle='Type of Workload',
		 xlabelfontsize=7.0,
		 ylabelfontsize=8.0,
		 ytitlesize=9.0,
		 doxlabels=True,
		 xlabelshift=[0,5],
		 )
	p = plotter()
	L = legend()

	for st, legtext, bgcol, fillpattern, fillcol, fillsize, fillskip in options:
		w = 'store="%s"' % st
		st = table(table=t, where=w)
		barargs = {'drawable': d,
				   'table': st,
				   'xfield': 'line',
				   'yfield': 'bandwidth',
				   'fill': True,
				   'barwidth': 1,
				   'legend': L,

				   # 'labelfield': 'iops',
				   # 'labelsize': 6.7,
				   # 'labelshift': [2, 5],
				   # 'labelrotate': 90,

				   'fillskip': fillskip,
				   'fillsize': fillsize,
				   'fillstyle': fillpattern,
				   'fillcolor': fillcol,
				   'legendtext': legtext,
				   'bgcolor': bgcol,


				   }


		p.verticalbars(**barargs)

		L.draw(c,
			   coord=[d.right() - 90, d.top() - 6],
			   style='right',
			   skipnext=2,
			   skipspace=45,
			   fontsize=6.5,
			   height=5,
			   hspace=2
			   )

	c.render()
	print 'Result file is created at "' + c.output_file + "'"

if __name__ == '__main__':
	plot()
