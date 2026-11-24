program main_flexion

  use constantes
  use methode

  implicit none

  ! Déclaration
  real(PR), dimension(:), allocatable :: x, w_exact, eey1, eey2, hy1, hy2, rky1, rky2, aby1, aby2
  real(PR), dimension(:), allocatable :: error_euler, error_heun, error_rk4, error_ab2
  real(PR) :: total_error_euler, total_error_heun, total_error_rk4, total_error_ab2
  integer :: i
  character(len=32) :: arg

  ! Pas de discrétisation : ./main [h]
  if (command_argument_count() >= 1) then
    call get_command_argument(1, arg)
    read(arg, *) h
  end if
  n = nint(L / h)
  h = L / n

  ! Allocation
  allocate(x(0:n), w_exact(0:n), eey1(0:n), eey2(0:n), hy1(0:n), hy2(0:n), rky1(0:n), rky2(0:n), aby1(0:n), aby2(0:n))
  allocate(error_euler(0:n), error_heun(0:n), error_rk4(0:n), error_ab2(0:n))

  ! Initialisation des coordonnées x
  do i = 0, n
      x(i) = i * h
  end do

  ! Calcul analytique
  call calcul_analytique(x, w_exact)

  ! Calcul numérique (Euler explicite)
  call calcul_euler(x, eey1, eey2)

  ! Calcul numérique (Heun)
  call calcul_heun(x, hy1, hy2)

  ! Calcul numérique (RK4)
  call calcul_rk4(x, rky1, rky2)

  ! Calcul numérique (AB2)
  call calcul_ab2(x, aby1, aby2)

  ! Calcul des erreurs totales
  total_error_euler = 0.0_PR
  total_error_heun = 0.0_PR
  total_error_rk4 = 0.0_PR
  total_error_ab2 = 0.0_PR

  do i = 0, n
      error_euler(i) = abs(w_exact(i) - eey1(i))
      error_heun(i)  = abs(w_exact(i) - hy1(i))
      error_rk4(i)   = abs(w_exact(i) - rky1(i))
      error_ab2(i)   = abs(w_exact(i) - aby1(i))

      total_error_euler = total_error_euler + error_euler(i)**2
      total_error_heun = total_error_heun + error_heun(i)**2
      total_error_rk4 = total_error_rk4 + error_rk4(i)**2
      total_error_ab2 = total_error_ab2 + error_ab2(i)**2
  end do

  ! Prendre la racine carrée des erreurs totales
  total_error_euler = sqrt(total_error_euler / (n + 1))
  total_error_heun = sqrt(total_error_heun / (n + 1))
  total_error_rk4 = sqrt(total_error_rk4 / (n + 1))
  total_error_ab2 = sqrt(total_error_ab2 / (n + 1))

  ! Écriture des résultats dans un fichier
  open(unit=10, file="resultats_flexion.dat")
  write(10, '(A)') "x (m)         w_exact (m)     w_euler (m)    w_heun (m)      w_rk4 (m)     w_ab2 (m)"
  do i = 0, n
      write(10, *) x(i), w_exact(i), eey1(i), hy1(i), rky1(i), aby1(i)
  end do
  close(10)

  ! Écriture des erreurs dans un fichier
  open(unit=20, file="erreurs_flexion.dat")
  write(20, '(A)') "x (m)         erreur_euler    erreur_heun    erreur_rk4    erreur_ab2"
  do i = 0, n
      write(20, *) x(i), error_euler(i), error_heun(i), error_rk4(i), error_ab2(i)
  end do
  close(20)

  ! Affichage des erreurs totales
  print *, "Erreur totale (Euler) :", total_error_euler
  print *, "Erreur totale (Heun) :", total_error_heun
  print *, "Erreur totale (RK4) :", total_error_rk4
  print *, "Erreur totale (AB2) :", total_error_ab2

  ! Affichage flèche max
    print *, "Flèche maximale (Analytique) :", minval(w_exact)
    print *, "Flèche maximale (Euler) :", minval(eey1)
    print *, "Flèche maximale (Heun) :", minval(hy1)
    print *, "Flèche maximale (RK4) :", minval(rky1)
    print *, "Flèche maximale (AB2) :", minval(aby1)

    



  ! Désallocation
  deallocate(x, w_exact, eey1, eey2, hy1, hy2, rky1, rky2, aby1, aby2, error_euler, error_heun, error_rk4, error_ab2)

end program main_flexion
