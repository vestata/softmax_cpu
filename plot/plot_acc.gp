set datafile separator ","
set terminal png size 1000,600
set output "plot/acc_softmax_plot.png"

set title "Softmax Accuracy Comparison"
set xlabel "Input Size"
set ylabel "Max Error"
set grid
set key outside top center

plot \
    'data/error_softmax_scalar.csv'        using 1:2 with lines title 'Safe softmax(Baseline)', \
    'data/error_softmax_avx2.csv'           using 1:2 with lines title 'AVX2', \
    'data/error_softmax_avx2_vexpf.csv'     using 1:2 with lines title 'AVX2_VEXPF', \
    'data/error_softmax_online_scalar.csv' using 1:2 with lines title 'Online_scalar'
