set datafile separator ","
set terminal png size 1000,600
set output 'plot/softmax_plot.png'

set title "Softmax Performance Comparison"
set xlabel "Input Size"
set ylabel "Execution Time (ms)"
set grid
set key outside top center

plot \
  'data/softmax_time_scalar.csv' every ::1 using 1:2 with linespoints title 'Scalar', \
  'data/softmax_time_avx2.csv' every ::1 using 1:2 with linespoints title 'AVX2'

