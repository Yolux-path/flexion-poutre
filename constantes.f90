module constantes
    
    implicit none

    integer, parameter      :: PR = 8                   ! Précision
    real(PR), parameter     :: g = 9.81_PR              ! Gravité
    real(PR), parameter     :: L = 0.8_PR               ! Longueur de la poutre
    real(PR), parameter     :: e = 2.1e11_PR            ! Module de Young
    real(PR), parameter     :: I_g = 4.98775e-10_PR     ! Moment quadratique
    real(PR), parameter     :: M = 0.616_PR             ! Masse de la poutre
    real(PR), parameter     :: F = 0.362_PR             ! Masse mise au bout de la poutre

    real(PR)                :: h = 1e-3_PR              ! Pas de discrétisation
    integer                 :: n                        ! Nombre d'intervalles, nint(L/h)



end module constantes