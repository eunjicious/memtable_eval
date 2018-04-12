from zplot import *

data_file='memtable.hit.64.dat'
ctype = 'pdf' if len(sys.argv) < 2 else sys.argv[1]
c = canvas(ctype, title=data_file, dimensions=[300, 140])

d = drawable(canvas=c, xrange=[89,102], yrange=[0,2000000, coord=[0,25],
             dimensions=['3in','1.85in'])

t = table(file=data_file)
c = canv

# background: green, with a yellow vertical grid
c.box(coord=[[0,0],[300,140]], fill=True, fillcolor='darkgreen', linewidth=0)
grid(drawable=d, y=False, xrange=[90,101], xstep=1, linecolor='yellow',
     linedash=[2,2])

p = plotter()
p.verticalbars(drawable=d, table=gt, xfield='c0', yfield='c1', fill=True,
               fillcolor='yellow', barwidth=0.7, linewidth=0, yloval=0,
               labelfield='c1', labelcolor='white', labelfont='Helvetica-Bold',
               labelsize=7.0)
p.verticalbars(drawable=d, table=lt, xfield='c0', yfield='c1', fill=True,
               fillcolor='red',    barwidth=0.7, linewidth=0, yloval=0,
               labelfield='c1', labelplace='o', labelanchor='c,h',
               labelcolor='white', labelfont='Helvetica-Bold', labelsize=7.0)

# a bit of a hack to get around that we don't support date fields (yet)
axis(drawable=d, style='x', xauto=[90,99,1], domajortics=False, xaxisposition=0,
     linewidth=0.5, xlabelfontsize=8.0, xlabelformat='\'%s', xlabelshift=[0,-30],
     linecolor='white', xlabelfontcolor='white')
axis(drawable=d, style='x', xmanual=[['00', 100],['01',101]], domajortics=False,
     xaxisposition=0, linewidth=0.5, xlabelfontsize=8.0, xlabelformat='\'%s',
     xlabelshift=[0,-30], doaxis=False, xlabelfontcolor='white')

c.text(coord=d.map([89.5,32]), text='Emerging growth fund annual return (%)',
       anchor='l', size=8.0, font='Courier-Bold', color='white')
c.text(coord=d.map([95.5,-24]), text='Calendar Year', size=8.0, color='white')

c.render()






