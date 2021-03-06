PROGRAM main

USE sdata, ONLY: DP, mode, tranw
USE InpOutp, ONLY: ounit, inp_read, bwrst, w_rst, bther
USE nodal, ONLY: forward, adjoint, fixedsrc, init
USE trans, ONLY: rod_eject, trod_eject
USE th, ONLY: cbsearch, cbsearcht

IMPLICIT NONE

REAL(DP) :: st, fn


CALL CPU_TIME(st)

CALL inp_read()

CALL Init()

SELECT CASE(mode)
    CASE('FIXEDSRC')
        CALL fixedsrc()
    CASE('ADJOINT')
        CALL adjoint()
    CASE('RODEJECT')
        IF (bther == 0) THEN
            CALL rod_eject()
        ELSE
            CALL trod_eject()
        END IF
    CASE('BCSEARCH')
        IF (bther == 0) THEN
            CALL cbsearch()
        ELSE
            CALL cbsearcht()
        END IF
    CASE DEFAULT
        CALL forward()
END SELECT

! Write Restart File if required
IF (bwrst == 1)    CALL w_rst()

IF (tranw) THEN
    WRITE(ounit,*)
    WRITE(ounit,*) "  WARNING: ONE OR MORE OUTER ITERATIONS DID NOT CONVERGE. YOU MAY NEED TO REDUCE TIME STEP"
    WRITE(*,*)
    WRITE(*,*) "  WARNING: ONE OR MORE OUTER ITERATIONS DID NOT CONVERGE. YOU MAY NEED TO REDUCE TIME STEP"
END IF

CALL CPU_TIME(fn)

WRITE(ounit,*)
WRITE(ounit,*)
WRITE(ounit,*) "Total time : ", fn-st, " seconds"

WRITE(*,*)
WRITE(*,*) "  ADPRES EXIT NORMALLY"

END PROGRAM main
