PROGRAM main
  IMPLICIT NONE
  ! ...Local Scalars...
  INCLUDE 'mpif.h'
  INTEGER :: i,n,myid, ntasks, ierr, islave
  INTEGER, DIMENSION(MPI_STATUS_SIZE) :: status
  INTEGER, PARAMETER :: master=0, msgtag1=11, msgtag2=12
  DOUBLE PRECISION, PARAMETER :: pi25dt = 3.141592653589793238462643d0
  DOUBLE PRECISION :: a,h,pi,sum,x,mypi
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
    !
    h = 1.0d0 / n ! stride
    !Calculation of the quadrature formula(summation)
    sum = 0.0d0

    DO i = 1+myid,n,ntasks
      x = h * (DBLE(i) - 0.5d0)
      sum = sum + 4.0 / (1.0 + x * x)
    END DO
    mypi = h * sum
    CALL MPI_Reduce(mypi, pi, 1, MPI_DOUBLE_PRECISION, MPI_SUM, 0,  MPI_COMM_WORLD, ierr)
    ! Output of the solution
    IF (myid == 0) THEN ! only master
      WRITE (*,*) pi, ABS(pi - pi25dt)
    END IF
  END DO
  
  CALL MPI_FINALIZE(ierr)

  !
  ! ...Format Declarations...
  !
  10000 format ( "Enter the number of intervals : (0 quits )" )
  10001 format ( i10 )

END PROGRAM main
