PROGRAM ex3
  USE omp_lib
  IMPLICIT NONE

  INTEGER, PARAMETER :: N=10000
  INTEGER, PARAMETER :: SEED=2531
  INTEGER :: randy = SEED
  REAL, DIMENSION(N) :: A
  REAL :: summ=0.0, runtime
  INTEGER :: flag
  INTEGER :: flg_temp

  runtime = omp_get_wtime()
  !$OMP PARALLEL SECTIONS
  ! first section --------->
  !$OMP SECTION
  call fill_rand(N, A)        ! Producer: fill an array of data
  !$OMP FLUSH
  !$OMP ATOMIC
  flag = flag + 1
  !$OMP FLUSH(flag)

  ! second section --------->
  !$OMP SECTION
  !$OMP FLUSH(flag)
  DO
    !$OMP FLUSH(flag)
    !$OMP CRITICAL
    flg_temp = flag
    !$OMP END CRITICAL
    IF(flg_temp==1) EXIT
    !$OMP FLUSH
    CALL Sum_array(N, A, summ)  ! Consumer: sum the array
  END DO

  !$OMP END PARALLEL SECTIONS

  runtime = omp_get_wtime() - runtime;
  WRITE(*,*) "In ", runtime, "seconds, The sum is ", summ
END PROGRAM ex3

! function to fill an array with random numbers
SUBROUTINE fill_rand(length, a)
  IMPLICIT NONE

  INTEGER, PARAMETER :: RAND_MULT=1366
  INTEGER, PARAMETER :: RAND_ADD=150889
  INTEGER, PARAMETER :: RAND_MOD=714025
  INTEGER, INTENT(IN) :: length
  REAL, INTENT(INOUT), DIMENSION(length) :: a
  REAL :: randy
  INTEGER :: i
  
  DO i=1, length
    randy = MOD(INT(RAND_MULT * randy + RAND_ADD), RAND_MOD)
    a(i) = randy / RAND_MOD
  END DO
END SUBROUTINE

! function to sum the elements of an array
SUBROUTINE Sum_array(length, a, summ)
  IMPLICIT NONE
  INTEGER, INTENT(IN) :: length
  REAL, INTENT(IN), DIMENSION(length) :: a
  REAL, INTENT(OUT) :: summ
  INTEGER :: i
  DO i=0, length
    summ = summ + a(i)
  END DO
END SUBROUTINE

