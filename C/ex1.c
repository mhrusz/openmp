#include <stdio.h>
#include <omp.h>
# define PAD 8
#define NUM_THREADS 4

static long num_steps = 100000;
double step;

int main()
{
  double pi, sum[NUM_THREADS][PAD];
  int i, ts_num;
  step = 1.0/(double)num_steps;
  // set number of used threads
  omp_set_num_threads(NUM_THREADS);
  #pragma omp parallel
  {
    int i, ts_nums, id;
    double x;
    // get curretn thread ID
    id = omp_get_thread_num();
    // get threads num
    ts_nums = omp_get_num_threads();

    // only first thread is specyfing the threads numbers
    if (id == 0) ts_num = ts_nums;

    for(i=id, sum[id][0]=0.0;i < num_steps;i=i+ts_nums)
    {
      x = (i+0.5)*step;
      sum[id][0] += 4.0/(1.0+x*x);
    }
  }
  // end of OMP PARALLEL

  for(i=0,pi=0.0; i<ts_num; i++) pi += sum[i][0]*step;
  printf("pi is %f\n", pi);
}
