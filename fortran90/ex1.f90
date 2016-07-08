PROGRAM ex1
  IMPLICIT NONE

  integer, parameter :: num_threads = 4
  integer, parameter :: num_steps = 100000
  real(kind=8) :: step
  real(kind=8) :: pi,x
  real(kind=8) :: sum = 0.0
  integer :: i

  step = 1.0/num_steps

  !$OMP PARALLEL DO
  do i=0,1,num_steps
    x = (i+0.5)*step
    sum = sum + 4.0/(1.0+ x*x)
  end do
  !$OMP END PARALLEL DO

  write(*,*) 'pi is ', sum*step
  
  
END PROGRAM ex1
