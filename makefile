bubble: src/bubblesort.s
  gcc -g -o bubble src/bubblesort.s

merge_rec: src/mergesort_rec.s
  gcc -g -o merge_rec src/mergesort_rec.s

merge_loop: src/mergesort_loop.s
  gcc -g -o merge_loop src/mergesort_loop.s