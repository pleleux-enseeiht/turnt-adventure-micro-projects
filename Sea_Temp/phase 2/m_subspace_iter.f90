
! This file is provided as part of the "projet long" for the Algebre Lineaire Numerique course
! at ENSEEIHT
! Date: 04/04/2012
! Authors: P. Amestoy, P. Berger, A. Buttari, Y. Diouane, S. Gratton, F.H. Rouet
!
! This file holds a FORTRAN module that includes the implementation 
! of the three variants of the subspace
! iteration method.
! All routines are empty, only the interface with related 
! declaration is provided
!  TO BE WRITTEN
! 
module m_subspace_iter
  implicit none
  private
  public :: subspace_iter_v0, subspace_iter_v1, subspace_iter_v2
contains





!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!
! Simple, basic version
!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  subroutine subspace_iter_v0(a, Y, w, n , m, maxit, eps, work,  &
       lwork, res, it, ierr)
    implicit none
    !! the subspace dimensions
    integer,          intent(in)                     :: n, m
    !! the target matrix                              
    double precision, dimension(n, n), intent(in)    :: a
    !! maximum # of iteration                         
    integer,          intent(in)                     :: maxit
    !! the tolerance for the stopping criterion       
    double precision, intent(in)                     :: eps
    !! the length of the workspace                    
    integer                                          :: lwork
    !! the workspace                                  
    double precision, dimension(lwork)               :: work
    !! the starting subspace. The computed eigenvectors will be
    !! returned in this array
    double precision, dimension(n, m), intent(inout) :: Y
    !! the m dominant eigenvalues
    double precision, dimension(m), intent(out)      :: w
    !! the returned residual                          
    double precision, intent(out)                    :: res
    !! the number of iteration to converge            
    integer,          intent(out)                    :: it
    !! a flag for signaling errors                    
    integer,          intent(out)                    :: ierr
    integer :: k , i , j, info
    double precision, dimension(n, n)                :: H
    double precision, dimension(n, m)                :: v
    double precision                                 :: aux
    double precision, dimension(m)                   :: mataux
    
    
    ierr = 0

    if(m.gt.n)then
       ierr=1
       return
    end if

    it = 0
    do while((res>eps).and.(it<=maxit))
	
        !! GRAMM SHMITT	: orthonormalisation of the columns of Y
        V(:,1)=Y(:,1)/NORME(Y(:,1),n)
        do i=2,m
			V(:,i)=Y(:,i)
            do j=1,i-1
                 V(:,i)=V(:,i)-(dot_product(Y(:,i),V(:,j))/dot_product(V(:,j),V(:,j)))*V(:,j)
            end do
            V(:,i)=V(:,i)/NORME(V(:,i),n)		
        end do

        !! Compute Y such as Y = A.V
        Y=matmul(A,V)

	!! Form the Rayleigh quotient H = transpose(V).A.V
        H=matmul(matmul(transpose(V),A),V)

	!! niter = niter + 1
        it=it+1

	!! Compute the the backward error : Invariance of the subspace V
        res=NORMEMATR2(matmul(A,V)-matmul(V,H),n,m)/NORMEMATR2(A,n,n)
    end do
    
    	!! Compute the spectral decomposition of the Rayleigh quotient 
    	call DSYEV('V', 'L', m, H, m, w, work, lwork, info)
	
	!! w : eigenvalues in ascending order => reverse w and H
	do i=1,m/2
		aux = w(i)
		w(i) = w(m-i+1)
		w(m-i+1) = aux
		
		mataux = H(:,i)
		H(:,i) = H(:,m-i+1)
		H(:,m-i+1) = mataux
	end do
	
	!! compute the eigenvectors of A with the eigenvectors of H
	Y = matmul(V,H)

    return

  end subroutine subspace_iter_v0




!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!
! V1 version of the subspace iteration with Rayleigh-Ritz.
! In this case the convergence can be checked for each eigenvector separately
! and the method can be stopped when the convereged eigenvectors capture
! as much as the trace of A as requested by the "percentage" argument
! 
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  subroutine subspace_iter_v1(a, v, w, n, m, percentage, maxit, eps, work,    &
       lwork, res_ev, it_ev, it, n_ev, ierr)
    implicit none
    !! the subspace dimensions
    integer,          intent(in)                            :: n, m
    !! the target matrix 
    double precision, dimension(n,n), intent(in)            :: a
    !! maximum # of iteration
    integer,          intent(in)                            :: maxit
    !! the number of the dominant eigenvectors to compute
    double precision, intent(in)                            :: percentage
    !! the tolerance for the stopping criterion
    double precision, intent(in)                            :: eps
    !! length of the workspace
    integer                                                 :: lwork
    !! the workspace
    double precision, dimension(lwork)                      :: work
    !! the starting subspace. The computed eigenvectors will be
    !! returned in this array
    double precision, dimension(n,m), intent(inout)         :: v
    !! the residuals for each eigenvector        
    double precision, dimension(n),   intent(out)           :: res_ev
    !! the n_ev dominant eigenvalues                        
    double precision, dimension(m),   intent(out)           :: w
    !! the number of iteration to converge for each eigenvector
    integer,          dimension(m),   intent(out)           :: it_ev
    !! the global number iteration to converge
    integer,          intent(out)                           :: it
    !! the number of converged eigenvectors
    integer,          intent(out)                           :: n_ev
    !! a flag for signaling errors
    integer,          intent(out)                           :: ierr
    integer 						    :: k , i , j, info, converge
    double precision					    :: percentReached
    double precision					    :: aux
    double precision					    :: trace
    double precision, dimension(n, n)			    :: H
    double precision, dimension(m)                          :: mataux


    ierr = 0
    !! initialization process ...
    if((percentage.gt.1d0)  .or. (percentage.lt.0d0)) then
       ierr=1
       return
    end if
    if(m.gt.n) then  
       ierr=1
       return
    end if

    it = 0
    do while((abs(percentReached-percentage)< eps).and.(n_ev<m).and.(it<=maxit))
		
	!! Compute V such that V = A Â· V
	v = matmul(A,v)
	
        !! GRAMM SHMITT	: orthonormalisation of the columns of v
        v(:,1)=v(:,1)/NORME(v(:,1),n)
        do i=2,m
            do j=1,i-1
                 v(:,i)=v(:,i)-(dot_product(v(:,i),v(:,j))/dot_product(v(:,j),v(:,j)))*v(:,j)
            end do
            v(:,i)=v(:,i)/NORME(v(:,i),n)		
        end do

        !! Rayleigh-Ritz projection applied on orthonormal vectors V and matrix A
		!! Compute the Rayleigh quotient H = V T A V 
		H=matmul(matmul(transpose(v),A),v)
		!! Compute the spectral decomposition of H with eigenvalues in descending order
		call DSYEV('V', 'L', m, H, m, w, work, lwork, info)
		!! w : eigenvalues in ascending order => reverse w and H
				do i=1,m/2
					aux = w(i)
					w(i) = w(m-i+1)
					w(m-i+1) = aux

					mataux = H(:,i)
					H(:,i) = H(:,m-i+1)
					H(:,m-i+1) = mataux
				end do
		!! Compute V = V X
		v = matmul(v,H)
		
	!! Calcul des rÃ©sidus de chaque vecteur
	do i=1,m
		res_ev(i)=NORME(matmul(A,V(:,i))-w(i)*V(:,i),n)/NORMEMATR2(A,n,n)
	end do
		
	!! Convergence
	converge=1
	i=1
	n_ev=0
	do while(converge==1.and.i<=m)
		if (res_ev(i)>eps) then
			converge=0
		elseif (res_ev(i)<eps.and.i>n_ev) then
			n_ev=n_ev+1
			it_ev(i)=it
		end if
		i=i+1
	end do
	
	!! Update percentReached
	percentReached=0
	do i=1, n_ev
		percentReached=percentReached+w(i)
	end do
	do i=1,m
		trace=0
		trace=trace+a(i,i)
	end do
	percentReached=(percentReached/trace)*100
			
	!! niter = niter + 1
        it=it+1

    end do

    return
  end subroutine subspace_iter_v1




!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!
! V2 is the subspace iteration method with Rayleigh-Ritz plus acceleration methods.
! V1 can be accelerated in two ways
! 1) by performing a block of p products y=A*v before reorthogonlizing
! 2) by defating each time some eigenvalue has converged
!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
  subroutine subspace_iter_v2(a, p, v, w, n, m, percentage, maxit, eps, work,    &
       lwork, res_ev, it_ev, it, n_ev, ierr)
    implicit none
    !! the subspace dimensions
    integer,          intent(in)                            :: n, m
    !! the iteration number ( the power)
    integer,          intent(in)                            :: p
    !! the regarded matrix 
    double precision, dimension(n,n),intent(in)             :: a
    !! maximum of iteration
    integer,          intent(in)                            :: maxit
    !! the number of the dominant eigen vector to compute
    double precision, intent(in)                            :: percentage
    !! a tolerance
    double precision, intent(in)                            :: eps
    !! length of the spacework
    integer                                                 :: lwork
    !! the spacework
    double precision, dimension(lwork)                      :: work
    !! the starting subspace
    double precision, dimension(n,m),intent(inout)          :: v
    !! the starting subspace. The computed eigenvectors will be
    !! returned in this array
    double precision, dimension(m),intent(out)              :: res_ev
    !! the n_ev dominant eigenvalues                        
    double precision, dimension(m),intent(out)              :: w
    !! the number of iteration  to converge for each eigenvector
    integer,          dimension(m),intent(out)              :: it_ev
    !! the number iteration to converge
    integer,          intent(out)                           :: it
    !! the number of the converged eigenvectors
    integer,          intent(out)                           :: n_ev
    !! a flag
    integer,intent(out)                                     :: ierr
    integer :: k , i , j, info, converge
    double precision					    :: percentReached
    double precision					    :: aux
    double precision					    :: trace
    double precision, dimension(n, n)			    :: H  
    double precision, dimension(m)                          :: mataux


    ierr = 0
    !! initialization process ...
    if(percentage .gt.1d0  .or.percentage .lt.0d0 )then
       ierr=1
       return
    end if
    if(m.gt.n)then
       ierr=1
       return
    end if
    if( p .eq.0 )then
       ierr=1
       return
    end if
  
    it = 0
    do while((abs(percentReached-percentage)< eps).and.(it<=maxit))
		
		!! Compute V such that V = A^p Â· V
		do i=1,p
			v = matmul(A,v)
		end do
	
        !! GRAMM SHMITT	: orthonormalisation of the columns of v
        v(:,1)=v(:,1)/NORME(v(:,1),n)
        do i=2,m
            do j=1,i-1
                 v(:,i)=v(:,i)-(dot_product(v(:,i),v(:,j))/dot_product(v(:,j),v(:,j)))*v(:,j)
            end do
            v(:,i)=v(:,i)/NORME(v(:,i),n)		
        end do

        !! Rayleigh-Ritz projection applied on orthonormal vectors V and matrix A
		!! Compute the Rayleigh quotient H = V T A V 
		H=matmul(matmul(transpose(v),A),v)
		!! Compute the spectral decomposition of H with eigenvalues in descending order
		call DSYEV('V', 'L', m, H, m, w, work, lwork, info)
		!! w : eigenvalues in ascending order => reverse w and H
				do i=1,m/2
					aux = w(i)
					w(i) = w(m-i+1)
					w(m-i+1) = aux

					mataux = H(:,i)
					H(:,i) = H(:,m-i+1)
					H(:,m-i+1) = mataux
				end do
		!! Compute V = V X
		v = matmul(v,H)
		
	!! Calcul des rÃ©sidus de chaque vecteur
	do i=1,m
		res_ev(i)=NORME(matmul(A,V(:,i))-w(i)*V(:,i),n)/NORMEMATR2(A,n,n)
	end do
		
	!! Convergence
	converge=1
	i=1
	do while(converge==1.and.i<=m)
		if (res_ev(i)>eps) then
			converge=0
		elseif (res_ev(i)<eps.and.i>n_ev) then
			n_ev=n_ev+1
			it_ev(i)=it
		end if
		i=i+1
	end do
	
	!! Update percentReached
	percentReached=0
	do i=1, n_ev
		percentReached=percentReached+w(i)
	end do
	do i=1,m
		trace=0
		trace=trace+a(i,i)
	end do
	percentReached=(percentReached/trace)*100
			
	!! niter = niter + 1
        it=it+1

    end do
    
    return
  end subroutine subspace_iter_v2

  
  

  
  
  
  
  
  
!**************************************************
       DOUBLE PRECISION FUNCTION NORME ( x, n)
       IMPLICIT NONE
! ---------------------------------------
! Objectif: NORME = || x || , with 2 norm
! ----------------------------------------
       INTEGER, INTENT(IN)           :: n
       DOUBLE PRECISION, INTENT(IN)  :: x(n)
!
!  Variables locales :
!  -----------------
!      Indices de boucles
       INTEGER i
!
!  Fonctions intrinseques
       INTRINSIC sqrt, dfloat

       NORME = dfloat(0)
       DO i=1, N
        NORME = NORME + x(i) *x(i)
       ENDDO
       NORME = sqrt(NORME)

       END FUNCTION NORME
!***************************************************
 
 
    
!***************************************************
       DOUBLE PRECISION FUNCTION NORMEMATR2 ( A, n,m)
       IMPLICIT NONE
! ---------------------------------------
! Objectif: NORMEMATR2 = || A || , with 2 norm
! ----------------------------------------
       INTEGER, INTENT(IN)           :: n,m
       double precision, dimension(n,m),intent(in):: A(n,m)
!
!  Variables locales :
!  -----------------
!      Indices de boucles
       INTEGER i, j
!
!  Fonctions intrinseques
       INTRINSIC sqrt, dfloat

       NORMEMATR2 = dfloat(0)
       DO i=1, N
		DO j=1, M
        NORMEMATR2 = NORMEMATR2 + A(i,j)*A(i,j)
       ENDDO
       NORMEMATR2 = sqrt(NORMEMATR2)
		ENDDO
       END FUNCTION NORMEMATR2
!***************************************************
       
       
end module m_subspace_iter



