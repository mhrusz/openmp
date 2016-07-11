PROGRAM ex1
  use omp_lib

  IMPLICIT NONE

  integer :: num_steps = 100000
  real :: step
  real :: pi, x
  real :: summ
  integer :: i

  step = 1.0/num_steps

  summ = 0.0
  !$OMP PARALLEL DO REDUCTION(+:summ)
  do i=0, num_steps
    x = (i+0.5)*step
    summ = summ + 4.0/(1.0+ x*x)
  end do
  !$OMP END PARALLEL DO

  write(*,*) 'pi is ', summ*step
  
END PROGRAM ex1
