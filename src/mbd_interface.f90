! This Source Code Form is subject to the terms of the Mozilla Public
! License, v. 2.0. If a copy of the MPL was not distributed with this
! file, You can obtain one at http://mozilla.org/MPL/2.0/.
module mbd_interface

use mpi

implicit none

private

public :: &
    sync_sum, broadcast, print_log, print_error, print_warning

real(8), parameter, public :: pi = acos(-1.d0)
integer, parameter, public :: legendre_precision = 8

interface sync_sum
    module procedure sync_sum_dble_
    module procedure sync_sum_vector_dble_
    module procedure sync_sum_matrix_dble_
    module procedure sync_sum_3d_dble_
    module procedure sync_sum_4d_dble_
    module procedure sync_sum_cmplx_
    module procedure sync_sum_vector_cmplx_
    module procedure sync_sum_matrix_cmplx_
    module procedure sync_sum_3d_cmplx_
    module procedure sync_sum_4d_cmplx_
end interface

interface broadcast
    module procedure broadcast_vector_dble_
    module procedure broadcast_matrix_dble_
    module procedure broadcast_3d_dble_
    module procedure broadcast_4d_dble_
    module procedure broadcast_vector_cmplx_
    module procedure broadcast_matrix_cmplx_
end interface

! external :: &
!     MPI_COMM_WORLD, MPI_DOUBLE_PRECISION, MPI_COMPLEX16, MPI_SUM, &
!     MPI_COMM_RANK, MPI_BCAST, MPI_ALLREDUCE

contains


subroutine sync_sum_dble_(x)
    real(8), intent(inout) :: x
    real(8) :: x_buff
    integer :: mpi_err

    call MPI_ALLREDUCE( &
        x, x_buff, 1, MPI_DOUBLE_PRECISION, &
        MPI_SUM, MPI_COMM_WORLD, mpi_err)
    x = x_buff
end subroutine


subroutine sync_sum_array_dble_(array, n_array)
    integer, intent(in) :: n_array
    real(8), intent(inout) :: array(n_array)

    real(8) :: array_buff(n_array)
    integer :: mpi_err

    call MPI_ALLREDUCE( &
        array, array_buff, n_array, MPI_DOUBLE_PRECISION, &
        MPI_SUM, MPI_COMM_WORLD, mpi_err)
    array = array_buff
end subroutine


subroutine sync_sum_vector_dble_(x)
    real(8), intent(inout) :: x(:)

    call sync_sum_array_dble_(x, size(x))
end subroutine


subroutine sync_sum_matrix_dble_(x)
    real(8), intent(inout) :: x(:, :)

    call  sync_sum_array_dble_(x, size(x))
end subroutine


subroutine sync_sum_3d_dble_(x)
    real(8), intent(inout) :: x(:, :, :)

    call  sync_sum_array_dble_(x, size(x))
end subroutine


subroutine sync_sum_4d_dble_(x)
    real(8), intent(inout) :: x(:, :, :, :)

    call  sync_sum_array_dble_(x, size(x))
end subroutine


subroutine sync_sum_cmplx_(x)
    complex(kind=8), intent(inout) :: x
    complex(kind=8) :: x_buff
    integer :: mpi_err

    call MPI_ALLREDUCE( &
        x, x_buff, 1, MPI_COMPLEX16, &
        MPI_SUM, MPI_COMM_WORLD, mpi_err)
    x = x_buff
end subroutine


subroutine sync_sum_array_cmplx_(array, n_array)
    integer, intent(in) :: n_array
    complex(kind=8), intent(inout) :: array(n_array)

    complex(kind=8) :: array_buff(n_array)
    integer :: mpi_err

    call MPI_ALLREDUCE( &
        array, array_buff, n_array, MPI_COMPLEX16, &
        MPI_SUM, MPI_COMM_WORLD, mpi_err)
    array = array_buff
end subroutine


subroutine sync_sum_vector_cmplx_(x)
    complex(kind=8), intent(inout) :: x(:)

    call sync_sum_array_cmplx_(x, size(x))
end subroutine


subroutine sync_sum_matrix_cmplx_(x)
    complex(kind=8), intent(inout) :: x(:, :)

    call  sync_sum_array_cmplx_(x, size(x))
end subroutine


subroutine sync_sum_3d_cmplx_(x)
    complex(kind=8), intent(inout) :: x(:, :, :)

    call  sync_sum_array_cmplx_(x, size(x))
end subroutine


subroutine sync_sum_4d_cmplx_(x)
    complex(kind=8), intent(inout) :: x(:, :, :, :)

    call  sync_sum_array_cmplx_(x, size(x))
end subroutine


subroutine broadcast_array_dble_(array, n_array)
    integer, intent(in) :: n_array
    real(8), intent(inout) :: array(n_array)

    integer :: mpi_err

    call MPI_BCAST(array, n_array, MPI_DOUBLE_PRECISION, 0, &
        MPI_COMM_WORLD, mpi_err)
end subroutine


subroutine broadcast_vector_dble_(x)
    real(8), intent(inout) :: x(:)

    call broadcast_array_dble_(x, size(x))
end subroutine


subroutine broadcast_matrix_dble_(x)
    real(8), intent(inout) :: x(:, :)

    call broadcast_array_dble_(x, size(x))
end subroutine


subroutine broadcast_3d_dble_(x)
    real(8), intent(inout) :: x(:, :, :)

    call broadcast_array_dble_(x, size(x))
end subroutine


subroutine broadcast_4d_dble_(x)
    real(8), intent(inout) :: x(:, :, :, :)

    call broadcast_array_dble_(x, size(x))
end subroutine


subroutine broadcast_array_cmplx_(array, n_array)
    integer, intent(in) :: n_array
    complex(8), intent(inout) :: array(n_array)

    integer :: mpi_err

    call MPI_BCAST(array, n_array, MPI_COMPLEX16, 0, &
        MPI_COMM_WORLD, mpi_err)
end subroutine


subroutine broadcast_vector_cmplx_(x)
    complex(8), intent(inout) :: x(:)

    call broadcast_array_cmplx_(x, size(x))
end subroutine


subroutine broadcast_matrix_cmplx_(x)
    complex(8), intent(inout) :: x(:, :)

    call broadcast_array_cmplx_(x, size(x))
end subroutine


subroutine print_log(str, mute)
    character(len=*), intent(in) :: str
    integer :: myid, error
    logical, optional :: mute

    if (present(mute)) then
        if (mute) return
    end if
    call MPI_COMM_RANK(MPI_COMM_WORLD, myid, error)
    if (myid == 0) then
        write (6, *) str
    end if
end subroutine


subroutine print_warning(str)
    character(len=*), intent(in) :: str
    integer :: myid, error

    call MPI_COMM_RANK(MPI_COMM_WORLD, myid, error)
    if (myid == 0) then
        write (0, *) "Warning: " // str
    end if
end subroutine


subroutine print_error(str)
    character(len=*), intent(in) :: str
    integer :: myid, error

    call MPI_COMM_RANK(MPI_COMM_WORLD, myid, error)
    if (myid == 0) then
        write (0, *) "Error: " // str
    end if
end subroutine


end module mbd_interface
