set terminal postscript eps color solid enhanced "Helvetica" 14
  
set style line 1 lc rgb 'red' lt 3 lw 1.5 pt 4 ps 1
set style line 2 lc rgb 'orange' lt 3 lw 1.5 pt 6 ps 1
set style line 3 lc rgb 'green' lt 3 lw 1.5 pt 8 ps 1.2
set style line 4 lc rgb 'blue' lt 3 lw 1.5 pt 2 ps 1
set style line 5 lc rgb 'violet' lt 3 lw 1.5 pt 14 ps 1.2
	    
set boxwidth 1
set size 0.5,0.55

set xlabel "# of Meals" offset 0,0
set xtics nomirror
set xrange[0:8]

set key on inside right top width -1 height 0.5 samplen 3 spacing 2 enhanced font ",12"
set ylabel "Delicious Score" offset 1,0
set yrange[0:110]
set ytics 0,20,100 nomirror

set output 'taste_with_meals.eps'
plot 'taste_with_meals.txt' using 1:($2):xtic(1) title "White" with linespoints ls 1, \
     '' using 1:($3) title "Brown" with linespoints ls 2, \
     '' using 1:($4) title "Chicken" with linespoints ls 3, \
     '' using 1:($5) title "Duck" with linespoints ls 4, \
     '' using 1:($6) title "Fried" with linespoints ls 5
	 
###################
reset
set terminal postscript eps color solid enhanced lw 1 "Helvetica" 14

set size 0.5, 0.55
set boxwidth 1
	  
set style histogram clustered gap 2 title
set style data histogram
set style fill solid border -1
        
set xlabel "Type of Rice" offset 0,-0.5
set xtics nomirror scale 0 rotate by -30 offset -0.5,-0.2

set key on inside vertical top left width 0.5 height 1 samplen 2 spacing 1.2 enhanced font ",12"
set ylabel "Delicious Score" offset 1,0
set ytics nomirror
set yrange[0:110]

set output "taste_with_freshness.eps"
plot newhistogram '', "taste_with_freshness.txt" using ($2):xtic(1) title "Fresh" fs pattern 3 linecolor rgb "orange", \
  '' using ($3) title "Overnight" fs pattern 1 linecolor rgb "blue"
