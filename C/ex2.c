#include <stdio.h>
#include <omp.h>
#define NUM_THREADS 4

static long num_steps = 10000000;
double step;

int main()
{
  double pi, sum;
  int i, ts_num;
  step = 1.0/(double)num_steps;
  // set number of used threads
  omp_set_num_threads(NUM_THREADS);
  #pragma omp parallel
  {
    int i, ts_nums, id;
    double x;
    double l_sum = 0.0;
    // get curretn thread ID
    id = omp_get_thread_num();
    // get threads num
    ts_nums = omp_get_num_threads();

    // only first thread is specyfing the threads numbers
    if (id == 0) ts_num = ts_nums;

    for(i=id=0.0;i < num_steps;i=i+ts_nums)
    {
      x = (i+0.5)*step;
      l_sum += 4.0/(1.0 + x*x);
    }
    // add to the global sum
    #pragma omp atomic
    sum += l_sum;
  }
  // end of OMP PARALLEL
  pi = sum*step;
  printf("pi is %f\n", pi);
}
