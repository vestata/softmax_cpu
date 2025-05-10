set datafile separator ","
set terminal png size 1000,600
set output 'plot/scalar_opt_time.png'

set title "Performence of Scalar safe softmax with different optimizatin level"
set xlabel "Input Size"
set ylabel "Execution Time (ms)"
set key top left
plot \
	'data/scalar_opt_O0_time.csv' every ::1 using 1:2  with linespoints title 'O0', \
	'data/scalar_opt_O1_time.csv' every ::1 using 1:2  with linespoints title 'O1', \
	'data/scalar_opt_O2_time.csv' every ::1 using 1:2  with linespoints title 'O2', \
	'data/scalar_opt_O3_time.csv' every ::1 using 1:2  with linespoints title 'O3', \
	'data/scalar_opt_Ofast_time.csv' every ::1 using 1:2  with linespoints title 'Ofast'

