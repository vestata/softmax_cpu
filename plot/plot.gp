set terminal pngcairo size 800,600 enhanced font 'Arial,10'
set output 'plot/softmax_plot.png'
set title 'Softmax Execution Time vs Input Size'
set xlabel 'Input Size'
set ylabel 'Execution Time (ms)'
set grid
set datafile separator comma
set key autotitle columnheader
plot 'data/softmax_time.csv' using 1:2 skip 1 with lines title 'Softmax'
