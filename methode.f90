module methode

  use constantes

  implicit none
  
  contains

  function momentZ(x) result(mz)
    real(PR), intent(in) :: x
    real(PR) :: mz

    mz = -(F*g*(L-x)) - ( (M*g*(L-x)**2) / (2*L) ) 

  end function

  
    ! Calcul analytique de la déformation
  subroutine calcul_analytique(x, w_exact)
    real(PR), intent(in) :: x(0:n)
    real(PR), intent(out) :: w_exact(0:n)
    real(PR) :: part1, part2
    integer :: i
  
    w_exact = 0.0_PR
    do i = 1, n
      part1 = (-F *g * x(i)**2 * (3*l - x(i))) / (6 * e * i_g)
      part2 = (M * g * x(i)**2) * (x(i)**2 - 4*l*x(i) + 6*l**2) / (24 * e * l * i_g)
      w_exact(i) = part1 - part2
    end do
  end subroutine calcul_analytique
  
    ! Méthode EE
  subroutine calcul_euler(x, y1, y2)
    real(PR), intent(in) :: x(0:n)
    real(PR), intent(out) :: y1(0:n), y2(0:n)
    integer :: i

    y1 = 0.0_PR   ! Déplacement initial (w(x=0) = 0)
    y2 = 0.0_PR   ! Pente initiale (w'(x=0) = 0)
    do i = 0, n-1
      y1(i+1) = y1(i) + h * y2(i)                    ! Maj
      y2(i+1) = y2(i) + h * ( momentZ(x(i)) / (e * i_g) )  ! Maj
    end do
  end subroutine calcul_euler
  
    ! Méthode Heun
  subroutine calcul_heun(x, y1, y2)
    real(PR), intent(in) :: x(0:n)
    real(PR), intent(out) :: y1(0:n), y2(0:n)
    integer :: i
    real(PR) :: k1, k2, y1_pred, y2_pred
  
    y1 = 0.0_PR
    y2 = 0.0_PR
    do i = 0, n-1
      ! Calcul des pentes
      k1 = momentZ(x(i)) / (e * i_g)
      
      ! Prédiction
      y1_pred = y1(i) + h * y2(i)
      y2_pred = y2(i) + h * k1
      
      ! Calcul de la pente au point prédit
      k2 = momentZ(x(i+1)) / (e * i_g)
      
      ! Correction (moyenne des pentes)
      y1(i+1) = y1(i) + h * 0.5_PR * (y2(i) + y2_pred)
      y2(i+1) = y2(i) + h * 0.5_PR * (k1 + k2)
    end do
  end subroutine calcul_heun
  
    ! Méthode RK4
  subroutine calcul_rk4(x, y1, y2)
    real(PR), intent(in) :: x(0:n)
    real(PR), intent(out) :: y1(0:n), y2(0:n)
    integer :: i
    real(PR) :: k1, k2, k3, k4, l1, l2, l3, l4
  
    y1 = 0.0_PR
    y2 = 0.0_PR
    do i = 0, n-1
      ! Premier pas
      k1 = y2(i)
      l1 = momentZ(x(i)) / (e * i_g)
      
      ! Deuxième pas
      k2 = y2(i) + h * l1 / 2.0_PR
      l2 = momentZ(x(i) + h/2.0_PR) / (e * i_g)
      
      ! Troisième pas
      k3 = y2(i) + h * l2 / 2.0_PR
      l3 = momentZ(x(i) + h/2.0_PR) / (e * i_g)
      
      ! Quatrième pas
      k4 = y2(i) + h * l3
      l4 = momentZ(x(i+1)) / (e * i_g)
      
      ! Mise à jour finale
      y1(i+1) = y1(i) + (h/6.0_PR) * (k1 + 2*k2 + 2*k3 + k4)
      y2(i+1) = y2(i) + (h/6.0_PR) * (l1 + 2*l2 + 2*l3 + l4)
    end do
  end subroutine calcul_rk4
  
  ! Méthode AB2
  subroutine calcul_ab2(x, y1, y2)
    real(PR), intent(in) :: x(0:n)
    real(PR), intent(out) :: y1(0:n), y2(0:n)
    integer :: i
    real(PR) :: f(0:n)

    y1 = 0.0_PR
    y2 = 0.0_PR

    f(0) = momentZ(x(0)) / (e * i_g)

    y1(1) = y1(0) + h * y2(0)
    y2(1) = y2(0) + h * f(0)

    f(1) = momentZ(x(1)) / (e * i_g)

    ! Boucle AB2
    do i = 1, n-1
      y1(i+1) = y1(i) + (h / 2.0_PR) * (3.0_PR * y2(i) - y2(i-1))
      y2(i+1) = y2(i) + (h / 2.0_PR) * (3.0_PR * f(i) - f(i-1))
      if (i < n) f(i+1) = momentZ(x(i+1)) / (e * i_g) 
    end do
  end subroutine calcul_ab2
  
  end module methode
  