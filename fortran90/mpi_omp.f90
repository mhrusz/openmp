PROGRAM main
  USE OMP_LIB
  IMPLICIT NONE
  ! ...Local Scalars...
  INCLUDE 'mpif.h'
  INTEGER :: i, n, myid, ntasks, ierr, islave, tid, ts_nums
  INTEGER, DIMENSION(MPI_STATUS_SIZE) :: status
  INTEGER, PARAMETER :: master=0, msgtag1=11, msgtag2=12
  DOUBLE PRECISION, PARAMETER :: pi25dt = 3.141592653589793238462643d0
  DOUBLE PRECISION :: a, h, pi, summ, x, mypi
  !
  !...Executable Statements...
  !
  CALL MPI_INIT(ierr)
  CALL MPI_COMM_RANK(MPI_COMM_WORLD, myid, ierr)
  CALL MPI_COMM_SIZE(MPI_COMM_WORLD, ntasks, ierr)

  DO
    IF (myid == 0) THEN ! only master
      ! Input
      WRITE (6,10000)
      READ (5,10001) n
    END IF
    CALL MPI_Bcast(n, 1, MPI_INTEGER, master,MPI_COMM_WORLD,ierr)
    IF (n==0) EXIT

    h = 1.0d0 / n ! stride
    !Calculation of the quadrature formula(summation)
    summ = 0.0d0
    !$OMP PARALLEL DO REDUCTION(+:summ) SHARED(myid,n,ntasks,h) PRIVATE(x,i)
    DO i = (n/ntasks)*myid, (myid+1)*(n/ntasks)-1
      x = h * (i + 0.5d0)
      summ = summ + 4.0 / (1.0 + x * x)
    END DO
    !$OMP END PARALLEL DO

    mypi = h * summ
    CALL MPI_Reduce(mypi, pi, 1, MPI_DOUBLE_PRECISION, MPI_SUM, 0,  MPI_COMM_WORLD, ierr)
    ! Output of the solution
    IF (myid == 0) THEN ! only master
      WRITE (*,*) pi, ABS(pi - pi25dt)
    END IF
  END DO ! ---- main loop end
  
  CALL MPI_FINALIZE(ierr)
  !
  ! ...Format Declarations...
  !
  10000 format ( "Enter the number of intervals : (0 quits )" )
  10001 format ( i10 )
END PROGRAM main
