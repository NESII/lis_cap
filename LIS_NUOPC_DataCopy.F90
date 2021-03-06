!-----------------------BEGIN NOTICE -- DO NOT EDIT-----------------------
! NASA Goddard Space Flight Center Land Information System (LIS) v7.0
!-------------------------END NOTICE -- DO NOT EDIT-----------------------
#define FILENAME "lis_nuopc_datacopy"
#define MODNAME "lis_nuopc_datacopy"
#include "LIS_NUOPC_Macros.h"

module LIS_NUOPC_DataCopy
!BOP
!
! !MODULE: LIS_NUOPC_DataCopy
!
! !DESCRIPTION:
!   This module contains data copy subroutines
!
! !REVISION HISTORY:
!  2017Jan06    Dan Rosen  Split from gluecode
!
! !USES:
  use ESMF
  use NUOPC
  use LIS_coreMod, only: &
    LIS_rc, &
    LIS_domain
  use noah33_lsmMod

  IMPLICIT NONE

  PRIVATE
!-----------------------------------------------------------------------------
! !PUBLIC MEMBER FUNCTIONS:
!-----------------------------------------------------------------------------
  public :: LIS_CopyToLIS
  public :: LIS_CopyToNoah_3_3
  public :: LIS_CopyFromLIS

!-----------------------------------------------------------------------------
! Interface definitions for copy from LIS 1D tiled data to 2D
!-----------------------------------------------------------------------------

  interface LIS_CopyToLIS
    module procedure LIS_FieldCopyToLisField
    module procedure LIS_FieldCopyToLisFarray
    module procedure LIS_ArrayCopyToLisArray
    module procedure LIS_ArrayCopyToLisFarray
    module procedure LIS_FarrayI4CopyToLisFarrayI4
    module procedure LIS_FarrayI8CopyToLisFarrayI8
    module procedure LIS_FarrayR8CopyToLisFarrayR4
    module procedure LIS_FarrayR4CopyToLisFarrayR4
    module procedure LIS_FarrayR8CopyToLisFarrayR8
  end interface

  interface LIS_CopyToNoah_3_3
    module procedure LIS_FieldCopyToNoah_3_3
    module procedure LIS_ArrayCopyToNoah_3_3
    module procedure LIS_FarrayR8CopyToNoah_3_3
    module procedure LIS_FarrayR4CopyToNoah_3_3
  end interface

  interface LIS_CopyFromLIS
    module procedure LIS_FieldCopyFromLisField
    module procedure LIS_FieldCopyFromLisFarray
    module procedure LIS_ArrayCopyFromLisArray
    module procedure LIS_ArrayCopyFromLisFarray
    module procedure LIS_FarrayI4CopyFromLisFarrayI4
    module procedure LIS_FarrayI8CopyFromLisFarrayI8
    module procedure LIS_FarrayR8CopyFromLisFarrayR4
    module procedure LIS_FarrayR4CopyFromLisFarrayR4
    module procedure LIS_FarrayR8CopyFromLisFarrayR8
  end interface

!-----------------------------------------------------------------------------
! !LOCAL VARIABLES:
!-----------------------------------------------------------------------------

contains

  !-----------------------------------------------------------------------------
  ! Copy Data To/From LIS 1D Array and 2D Array
  !-----------------------------------------------------------------------------

#undef METHOD
#define METHOD "LIS_FieldCopyToLisField"

  subroutine LIS_FieldCopyToLisField(field,fieldLIS,nest,rc)
! !ARGUMENTS:
    type(ESMF_Field),intent(in)            :: field
    type(ESMF_Field),intent(inout)         :: fieldLIS
    integer,intent(in)                     :: nest
    integer,intent(out)                    :: rc
! !ARGUMENTS:
    type(ESMF_Array)                        :: array
    type(ESMF_Array)                        :: arrayLIS

    rc = ESMF_SUCCESS

    call ESMF_FieldGet(field=field,array=array,rc=rc)
    if(ESMF_STDERRORCHECK(rc)) return ! bail out
    call ESMF_FieldGet(field=fieldLIS,array=arrayLIS,rc=rc)
    if(ESMF_STDERRORCHECK(rc)) return ! bail out
    call LIS_CopyToLIS(array=array,arrayLIS=arrayLIS,nest=nest,rc=rc)
    if(ESMF_STDERRORCHECK(rc)) return ! bail out
  end subroutine

  !-----------------------------------------------------------------------------

#undef METHOD
#define METHOD "LIS_FieldCopyToLisFarray"

  subroutine LIS_FieldCopyToLisFarray(field,farrayLIS,nest,rc)
! !ARGUMENTS:
    type(ESMF_Field),intent(in)            :: field
    real,intent(inout),pointer             :: farrayLIS(:)
    integer,intent(in)                     :: nest
    integer,intent(out)                    :: rc
! !ARGUMENTS:
    type(ESMF_Array)                        :: array

    rc = ESMF_SUCCESS

    call ESMF_FieldGet(field=field,array=array,rc=rc)
    if(ESMF_STDERRORCHECK(rc)) return ! bail out
    call LIS_CopyToLIS(array=array,farrayLIS=farrayLIS,nest=nest,rc=rc)
    if(ESMF_STDERRORCHECK(rc)) return ! bail out
  end subroutine

  !-----------------------------------------------------------------------------

#undef METHOD
#define METHOD "LIS_FieldCopyToNoah_3_3"

  subroutine LIS_FieldCopyToNoah_3_3(field,stdName,nest,rc)
! !ARGUMENTS:
    type(ESMF_Field),intent(in)            :: field
    character(*),intent(in)                :: stdName
    integer,intent(in)                     :: nest
    integer,intent(out)                    :: rc
! !ARGUMENTS:
    type(ESMF_Array)                        :: array

    rc = ESMF_SUCCESS

    call ESMF_FieldGet(field=field,array=array,rc=rc)
    if(ESMF_STDERRORCHECK(rc)) return ! bail out
    call LIS_CopyToNoah_3_3(array=array,stdName=stdName,nest=nest,rc=rc)
    if(ESMF_STDERRORCHECK(rc)) return ! bail out
  end subroutine

  !-----------------------------------------------------------------------------

#undef METHOD
#define METHOD "LIS_FieldCopyFromLisField"

  subroutine LIS_FieldCopyFromLisField(fieldLIS,field,nest,rc)
! !ARGUMENTS:
    type(ESMF_Field),intent(in)            :: fieldLIS
    type(ESMF_Field),intent(inout)         :: field
    integer,intent(in)                     :: nest
    integer,intent(out)                    :: rc
! !ARGUMENTS:
    type(ESMF_Array)                       :: arrayLIS
    type(ESMF_Array)                       :: array

    rc = ESMF_SUCCESS

    call ESMF_FieldGet(field=fieldLIS,array=arrayLIS,rc=rc)
    if(ESMF_STDERRORCHECK(rc)) return ! bail out
    call ESMF_FieldGet(field=field,array=array,rc=rc)
    if(ESMF_STDERRORCHECK(rc)) return ! bail out
    call LIS_CopyFromLIS(arrayLIS=arrayLIS,array=array,nest=nest,rc=rc)
    if(ESMF_STDERRORCHECK(rc)) return ! bail out
  end subroutine

  !-----------------------------------------------------------------------------

#undef METHOD
#define METHOD "LIS_FieldCopyFromLisFarray"

  subroutine LIS_FieldCopyFromLisFarray(farrayLIS,field,nest,rc)
! !ARGUMENTS:
    real,intent(in),pointer                :: farrayLIS(:)
    type(ESMF_Field),intent(inout)         :: field
    integer,intent(in)                     :: nest
    integer,intent(out)                    :: rc
! !ARGUMENTS:
    type(ESMF_Array)                       :: array

    rc = ESMF_SUCCESS

    call ESMF_FieldGet(field=field,array=array,rc=rc)
    if(ESMF_STDERRORCHECK(rc)) return ! bail out
    call LIS_CopyFromLIS(farrayLIS=farrayLIS,array=array,nest=nest,rc=rc)
    if(ESMF_STDERRORCHECK(rc)) return ! bail out
  end subroutine

  !-----------------------------------------------------------------------------

#undef METHOD
#define METHOD "LIS_ArrayCopyToLisArray"

  subroutine LIS_ArrayCopyToLisArray(array,arrayLIS,nest,rc)
! !ARGUMENTS:
    type(ESMF_Array),intent(in)             :: array
    type(ESMF_Array),intent(inout)          :: arrayLIS
    integer,intent(in)                      :: nest
    integer,intent(out)                     :: rc
! !LOCAL VARIABLES:
    integer                         :: localDeCount, localDeCountLIS
    type(ESMF_TypeKind_Flag)        :: typekind, typekindLIS
    integer                         :: rank,rankLIS
    integer                         :: deIndex
    integer(ESMF_KIND_I4),pointer   :: farrayLIS_I4(:)
    integer(ESMF_KIND_I8),pointer   :: farrayLIS_I8(:)
    real(ESMF_KIND_R4),pointer      :: farrayLIS_R4(:)
    real(ESMF_KIND_R8),pointer      :: farrayLIS_R8(:)
    integer(ESMF_KIND_I4),pointer   :: farray_I4(:,:)
    integer(ESMF_KIND_I8),pointer   :: farray_I8(:,:)
    real(ESMF_KIND_R4),pointer      :: farray_R4(:,:)
    real(ESMF_KIND_R8),pointer      :: farray_R8(:,:)
!
! !DESCRIPTION:
!  This routine copies from the cap to LIS or from LIS to the cap
!
!EOP
    rc = ESMF_SUCCESS

    call ESMF_ArrayGet(arrayLIS,typekind=typekindLIS,rank=rankLIS, &
      localDeCount=localDeCountLIS,rc=rc)
    if (ESMF_STDERRORCHECK(rc)) return
    call ESMF_ArrayGet(array,typekind=typekind,rank=rank, &
      localDeCount=localDeCount,rc=rc)
    if (ESMF_STDERRORCHECK(rc)) return

    if (rank /= 2) then
      call ESMF_LogSetError(ESMF_RC_ARG_OUTOFRANGE, &
        msg="Cannot copy. Array is not a 2D array.", &
        line=__LINE__, file=FILENAME, rcToReturn=rc)
      return  ! bail out
    endif
    if (rankLIS /= 1) then
      call ESMF_LogSetError(ESMF_RC_ARG_OUTOFRANGE, &
        msg="Cannot copy. LIS array is not a 1D tile array.", &
        line=__LINE__, file=FILENAME, rcToReturn=rc)
      return  ! bail out
    endif
    if (localDeCount /= localDeCountLIS) then
      call ESMF_LogSetError(ESMF_RC_ARG_OUTOFRANGE, &
        msg="Cannot copy. LIS array does not match array decomposition.", &
        line=__LINE__, file=FILENAME, rcToReturn=rc)
      return  ! bail out
    endif
    if (typekind /= typekindLIS) then
      call ESMF_LogSetError(ESMF_RC_ARG_OUTOFRANGE, &
        msg="Cannot copy. LIS array typekind does not match array typekind.", &
        line=__LINE__, file=FILENAME, rcToReturn=rc)
      return  ! bail out
    endif

    if(typekind==ESMF_TYPEKIND_I4) then
      call ESMF_ArrayGet(array,farrayPtr=farray_I4,rc=rc)
      if(ESMF_STDERRORCHECK(rc)) return ! bail out
      call ESMF_ArrayGet(arrayLIS,farrayPtr=farrayLIS_I4,rc=rc)
      if(ESMF_STDERRORCHECK(rc)) return ! bail out
      call LIS_CopyToLIS(farray=farray_I4,farrayLIS=farrayLIS_I4,nest=nest,rc=rc)
      if(ESMF_STDERRORCHECK(rc)) return ! bail out
    elseif(typekind==ESMF_TYPEKIND_I8) then
      call ESMF_ArrayGet(array,farrayPtr=farray_I8,rc=rc)
      if(ESMF_STDERRORCHECK(rc)) return ! bail out
      call ESMF_ArrayGet(arrayLIS,farrayPtr=farrayLIS_I8,rc=rc)
      if(ESMF_STDERRORCHECK(rc)) return ! bail out
      call LIS_CopyToLIS(farray=farray_I8,farrayLIS=farrayLIS_I8,nest=nest,rc=rc)
      if(ESMF_STDERRORCHECK(rc)) return ! bail out
    elseif(typekind==ESMF_TYPEKIND_R4) then
      call ESMF_ArrayGet(array,farrayPtr=farray_R4,rc=rc)
      if(ESMF_STDERRORCHECK(rc)) return ! bail out
      call ESMF_ArrayGet(arrayLIS,farrayPtr=farrayLIS_R4,rc=rc)
      if(ESMF_STDERRORCHECK(rc)) return ! bail out
      call LIS_CopyToLIS(farray=farray_R4,farrayLIS=farrayLIS_R4,nest=nest,rc=rc)
      if(ESMF_STDERRORCHECK(rc)) return ! bail out
    elseif(typekind==ESMF_TYPEKIND_R8) then
      call ESMF_ArrayGet(array,farrayPtr=farray_R8,rc=rc)
      if(ESMF_STDERRORCHECK(rc)) return ! bail out
      call ESMF_ArrayGet(arrayLIS,farrayPtr=farrayLIS_R8,rc=rc)
      if(ESMF_STDERRORCHECK(rc)) return ! bail out
      call LIS_CopyToLIS(farray=farray_R8,farrayLIS=farrayLIS_R8,nest=nest,rc=rc)
      if(ESMF_STDERRORCHECK(rc)) return ! bail out
    else
      call ESMF_LogSetError(ESMF_RC_NOT_IMPL, &
        msg="Typekind copy not implemented.",rcToReturn=rc)
      return
    endif
  end subroutine

  !-----------------------------------------------------------------------------

#undef METHOD
#define METHOD "LIS_ArrayCopyToNoah_3_3"

  subroutine LIS_ArrayCopyToNoah_3_3(array,stdName,nest,rc)
! !ARGUMENTS:
    type(ESMF_Array),intent(in)             :: array
    character(*),intent(in)                 :: stdName
    integer,intent(in)                      :: nest
    integer,intent(out)                     :: rc
! !LOCAL VARIABLES:
    integer                         :: localDeCount
    type(ESMF_TypeKind_Flag)        :: typekind
    integer                         :: rank
    real(ESMF_KIND_R4),pointer      :: farray_R4(:,:)
    real(ESMF_KIND_R8),pointer      :: farray_R8(:,:)
!
! !DESCRIPTION:
!  
!
!EOP
    rc = ESMF_SUCCESS

    call ESMF_ArrayGet(array,typekind=typekind,rank=rank, &
      localDeCount=localDeCount,rc=rc)
    if (ESMF_STDERRORCHECK(rc)) return

    if (rank /= 2) then
      call ESMF_LogSetError(ESMF_RC_ARG_OUTOFRANGE, &
        msg="Cannot copy. Array is not a 2D array.", &
        line=__LINE__, file=FILENAME, rcToReturn=rc)
      return  ! bail out
    endif
    if (localDeCount /= 1) then
      call ESMF_LogSetError(ESMF_RC_ARG_OUTOFRANGE, &
        msg="Cannot copy. Local DE count is not 1.", &
        line=__LINE__, file=FILENAME, rcToReturn=rc)
      return  ! bail out
    endif

    if(typekind==ESMF_TYPEKIND_R4) then
      call ESMF_ArrayGet(array,farrayPtr=farray_R4,rc=rc)
      if(ESMF_STDERRORCHECK(rc)) return ! bail out
      call LIS_CopyToNoah_3_3(farray=farray_R4,stdName=stdName,nest=nest,rc=rc)
      if(ESMF_STDERRORCHECK(rc)) return ! bail out
    elseif(typekind==ESMF_TYPEKIND_R8) then
      call ESMF_ArrayGet(array,farrayPtr=farray_R8,rc=rc)
      if(ESMF_STDERRORCHECK(rc)) return ! bail out
      call LIS_CopyToNoah_3_3(farray=farray_R8,stdName=stdName,nest=nest,rc=rc)
      if(ESMF_STDERRORCHECK(rc)) return ! bail out
    else
      call ESMF_LogSetError(ESMF_RC_NOT_IMPL, &
        msg="Typekind copy not implemented.",rcToReturn=rc)
      return
    endif
  end subroutine

  !-----------------------------------------------------------------------------

#undef METHOD
#define METHOD "LIS_ArrayCopyToLisFarray"

  subroutine LIS_ArrayCopyToLisFarray(array,farrayLIS,nest,rc)
! !ARGUMENTS:
    type(ESMF_Array),intent(in)             :: array
    real,intent(inout),pointer              :: farrayLIS(:)
    integer,intent(in)                      :: nest
    integer,intent(out)                     :: rc
! !LOCAL VARIABLES:
    integer                         :: localDeCount
    type(ESMF_TypeKind_Flag)        :: typekind
    integer                         :: rank
    real(ESMF_KIND_R4),pointer      :: farray_R4(:,:)
    real(ESMF_KIND_R8),pointer      :: farray_R8(:,:)
!
! !DESCRIPTION:
!  This routine copies from the cap to LIS or from LIS to the cap
!
!EOP
    rc = ESMF_SUCCESS

    call ESMF_ArrayGet(array,typekind=typekind,rank=rank, &
      localDeCount=localDeCount,rc=rc)
    if (ESMF_STDERRORCHECK(rc)) return

    if (rank /= 2) then
      call ESMF_LogSetError(ESMF_RC_ARG_OUTOFRANGE, &
        msg="Cannot copy. Array is not a 2D array.", &
        line=__LINE__, file=FILENAME, rcToReturn=rc)
      return  ! bail out
    endif
    if (localDeCount /= 1) then
      call ESMF_LogSetError(ESMF_RC_ARG_OUTOFRANGE, &
        msg="Cannot copy. Array local decomposition count must be 1.", &
        line=__LINE__, file=FILENAME, rcToReturn=rc)
      return  ! bail out
    endif
    if (typekind /= ESMF_TYPEKIND_R4 .AND. typekind /= ESMF_TYPEKIND_R8) then
      call ESMF_LogSetError(ESMF_RC_ARG_OUTOFRANGE, &
        msg="Cannot copy. LIS array typekind does not match array typekind.", &
        line=__LINE__, file=FILENAME, rcToReturn=rc)
      return  ! bail out
    endif

    if(typekind==ESMF_TYPEKIND_R4) then
      call ESMF_ArrayGet(array,farrayPtr=farray_R4,rc=rc)
      if(ESMF_STDERRORCHECK(rc)) return ! bail out
      call LIS_CopyToLIS(farray=farray_R4,farrayLIS=farrayLIS,nest=nest,rc=rc)
      if(ESMF_STDERRORCHECK(rc)) return ! bail out
    elseif(typekind==ESMF_TYPEKIND_R8) then
      call ESMF_ArrayGet(array,farrayPtr=farray_R8,rc=rc)
      if(ESMF_STDERRORCHECK(rc)) return ! bail out
      call LIS_CopyToLIS(farray=farray_R8,farrayLIS=farrayLIS,nest=nest,rc=rc)
      if(ESMF_STDERRORCHECK(rc)) return ! bail out
    else
      call ESMF_LogSetError(ESMF_RC_NOT_IMPL, &
        msg="Typekind copy not implemented.",rcToReturn=rc)
      return
    endif
  end subroutine

  !-----------------------------------------------------------------------------

#undef METHOD
#define METHOD "LIS_ArrayCopyFromLisArray"

  subroutine LIS_ArrayCopyFromLisArray(arrayLIS,array,nest,rc)
! !ARGUMENTS:
    type(ESMF_Array),intent(inout)          :: arrayLIS
    type(ESMF_Array),intent(in)             :: array
    integer,intent(in)                      :: nest
    integer,intent(out)                     :: rc
! !LOCAL VARIABLES:
    integer                         :: localDeCount, localDeCountLIS
    type(ESMF_TypeKind_Flag)        :: typekind, typekindLIS
    integer                         :: rank,rankLIS
    integer                         :: deIndex
    integer(ESMF_KIND_I4),pointer   :: farrayLIS_I4(:)
    integer(ESMF_KIND_I8),pointer   :: farrayLIS_I8(:)
    real(ESMF_KIND_R4),pointer      :: farrayLIS_R4(:)
    real(ESMF_KIND_R8),pointer      :: farrayLIS_R8(:)
    integer(ESMF_KIND_I4),pointer   :: farray_I4(:,:)
    integer(ESMF_KIND_I8),pointer   :: farray_I8(:,:)
    real(ESMF_KIND_R4),pointer      :: farray_R4(:,:)
    real(ESMF_KIND_R8),pointer      :: farray_R8(:,:)
!
! !DESCRIPTION:
!  This routine copies from the cap to LIS or from LIS to the cap
!
!EOP
    rc = ESMF_SUCCESS

    call ESMF_ArrayGet(arrayLIS,typekind=typekindLIS,rank=rankLIS, &
      localDeCount=localDeCountLIS,rc=rc)
    if (ESMF_STDERRORCHECK(rc)) return
    call ESMF_ArrayGet(array,typekind=typekind,rank=rank, &
      localDeCount=localDeCount,rc=rc)
    if (ESMF_STDERRORCHECK(rc)) return

    if (rank /= 2) then
      call ESMF_LogSetError(ESMF_RC_ARG_OUTOFRANGE, &
        msg="Cannot copy. Array is not a 2D array.", &
        line=__LINE__, file=FILENAME, rcToReturn=rc)
      return  ! bail out
    endif
    if (rankLIS /= 1) then
      call ESMF_LogSetError(ESMF_RC_ARG_OUTOFRANGE, &
        msg="Cannot copy. LIS array is not a 1D tile array.", &
        line=__LINE__, file=FILENAME, rcToReturn=rc)
      return  ! bail out
    endif
    if (localDeCount /= localDeCountLIS) then
      call ESMF_LogSetError(ESMF_RC_ARG_OUTOFRANGE, &
        msg="Cannot copy. LIS array does not match array decomposition.", &
        line=__LINE__, file=FILENAME, rcToReturn=rc)
      return  ! bail out
    endif
    if (typekind /= typekindLIS) then
      call ESMF_LogSetError(ESMF_RC_ARG_OUTOFRANGE, &
        msg="Cannot copy. LIS array typekind does not match array typekind.", &
        line=__LINE__, file=FILENAME, rcToReturn=rc)
      return  ! bail out
    endif

    if(typekind==ESMF_TYPEKIND_I4) then
      call ESMF_ArrayGet(array,farrayPtr=farray_I4,rc=rc)
      if(ESMF_STDERRORCHECK(rc)) return ! bail out
      call ESMF_ArrayGet(arrayLIS,farrayPtr=farrayLIS_I4,rc=rc)
      if(ESMF_STDERRORCHECK(rc)) return ! bail out
      call LIS_CopyFromLIS(farrayLIS=farrayLIS_I4,farray=farray_I4,nest=nest,rc=rc)
      if(ESMF_STDERRORCHECK(rc)) return ! bail out
    elseif(typekind==ESMF_TYPEKIND_I8) then
      call ESMF_ArrayGet(array,farrayPtr=farray_I8,rc=rc)
      if(ESMF_STDERRORCHECK(rc)) return ! bail out
      call ESMF_ArrayGet(arrayLIS,farrayPtr=farrayLIS_I8,rc=rc)
      if(ESMF_STDERRORCHECK(rc)) return ! bail out
      call LIS_CopyFromLIS(farrayLIS=farrayLIS_I8,farray=farray_I8,nest=nest,rc=rc)
      if(ESMF_STDERRORCHECK(rc)) return ! bail out
    elseif(typekind==ESMF_TYPEKIND_R4) then
      call ESMF_ArrayGet(array,farrayPtr=farray_R4,rc=rc)
      if(ESMF_STDERRORCHECK(rc)) return ! bail out
      call ESMF_ArrayGet(arrayLIS,farrayPtr=farrayLIS_R4,rc=rc)
      if(ESMF_STDERRORCHECK(rc)) return ! bail out
      call LIS_CopyFromLIS(farrayLIS=farrayLIS_R4,farray=farray_R4,nest=nest,rc=rc)
      if(ESMF_STDERRORCHECK(rc)) return ! bail out
    elseif(typekind==ESMF_TYPEKIND_R8) then
      call ESMF_ArrayGet(array,farrayPtr=farray_R8,rc=rc)
      if(ESMF_STDERRORCHECK(rc)) return ! bail out
      call ESMF_ArrayGet(arrayLIS,farrayPtr=farrayLIS_R8,rc=rc)
      if(ESMF_STDERRORCHECK(rc)) return ! bail out
      call LIS_CopyFromLIS(farrayLIS=farrayLIS_R8,farray=farray_R8,nest=nest,rc=rc)
      if(ESMF_STDERRORCHECK(rc)) return ! bail out
    else
      call ESMF_LogSetError(ESMF_RC_NOT_IMPL, &
        msg="Typekind copy not implemented.",rcToReturn=rc)
      return
    endif
  end subroutine

  !-----------------------------------------------------------------------------

#undef METHOD
#define METHOD "LIS_ArrayCopyFromLisFarray"

  subroutine LIS_ArrayCopyFromLisFarray(farrayLIS,array,nest,rc)
! !ARGUMENTS:
    real,intent(in),pointer                 :: farrayLIS(:)
    type(ESMF_Array),intent(inout)          :: array
    integer,intent(in)                      :: nest
    integer,intent(out)                     :: rc
! !LOCAL VARIABLES:
    integer                         :: localDeCount
    type(ESMF_TypeKind_Flag)        :: typekind
    integer                         :: rank
    real(ESMF_KIND_R4),pointer      :: farray_R4(:,:)
    real(ESMF_KIND_R8),pointer      :: farray_R8(:,:)
!
! !DESCRIPTION:
!  This routine copies from the cap to LIS or from LIS to the cap
!
!EOP
    rc = ESMF_SUCCESS

    call ESMF_ArrayGet(array,typekind=typekind,rank=rank, &
      localDeCount=localDeCount,rc=rc)
    if (ESMF_STDERRORCHECK(rc)) return

    if (rank /= 2) then
      call ESMF_LogSetError(ESMF_RC_ARG_OUTOFRANGE, &
        msg="Cannot copy. Array is not a 2D array.", &
        line=__LINE__, file=FILENAME, rcToReturn=rc)
      return  ! bail out
    endif
    if (localDeCount /= 1) then
      call ESMF_LogSetError(ESMF_RC_ARG_OUTOFRANGE, &
        msg="Local array decomposition count must be 1.", &
        line=__LINE__, file=FILENAME, rcToReturn=rc)
      return  ! bail out
    endif
    if (typekind /= ESMF_TYPEKIND_R4 .AND. typekind /= ESMF_TYPEKIND_R8) then
      call ESMF_LogSetError(ESMF_RC_ARG_OUTOFRANGE, &
        msg="Cannot copy. Array typekind does not match array typekind.", &
        line=__LINE__, file=FILENAME, rcToReturn=rc)
      return  ! bail out
    endif

    if(typekind==ESMF_TYPEKIND_R4) then
      call ESMF_ArrayGet(array,farrayPtr=farray_R4,rc=rc)
      if(ESMF_STDERRORCHECK(rc)) return ! bail out
      call LIS_CopyFromLIS(farrayLIS=farrayLIS,farray=farray_R4,nest=nest,rc=rc)
      if(ESMF_STDERRORCHECK(rc)) return ! bail out
    elseif(typekind==ESMF_TYPEKIND_R8) then
      call ESMF_ArrayGet(array,farrayPtr=farray_R8,rc=rc)
      if(ESMF_STDERRORCHECK(rc)) return ! bail out
      call LIS_CopyFromLIS(farrayLIS=farrayLIS,farray=farray_R8,nest=nest,rc=rc)
      if(ESMF_STDERRORCHECK(rc)) return ! bail out
    else
      call ESMF_LogSetError(ESMF_RC_NOT_IMPL, &
        msg="Typekind copy not implemented.",rcToReturn=rc)
      return
    endif
  end subroutine

  !-----------------------------------------------------------------------------

#undef METHOD
#define METHOD "LIS_FarrayI4CopyToLisFarrayI4"

  subroutine LIS_FarrayI4CopyToLisFarrayI4(farray,farrayLIS,nest,rc)
! !ARGUMENTS:
    integer(ESMF_KIND_I4),intent(in),pointer    :: farray(:,:)
    integer(ESMF_KIND_I4),intent(inout),pointer :: farrayLIS(:)
    integer,intent(in)                          :: nest
    integer,intent(out)                         :: rc
! !LOCAL VARIABLES:
    integer                         :: tile, col, row
! !DESCRIPTION:
!  This routine copies from a 2D array to an LIS 1D array
!EOP
    rc = ESMF_SUCCESS
    do tile=1,LIS_rc%ntiles(nest)
      col = LIS_domain(nest)%tile(tile)%col
      row = LIS_domain(nest)%tile(tile)%row
      farrayLIS(tile) = farray(col,row)
    enddo
  end subroutine

  !-----------------------------------------------------------------------------

#undef METHOD
#define METHOD "LIS_FarrayI8CopyToLisFarrayI8"

  subroutine LIS_FarrayI8CopyToLisFarrayI8(farray,farrayLIS,nest,rc)
! !ARGUMENTS:
    integer(ESMF_KIND_I8),intent(in),pointer    :: farray(:,:)
    integer(ESMF_KIND_I8),intent(inout),pointer :: farrayLIS(:)
    integer,intent(in)                          :: nest
    integer,intent(out)                         :: rc
! !LOCAL VARIABLES:
    integer                         :: tile, col, row
! !DESCRIPTION:
!  This routine copies from a 2D array to an LIS 1D array
!EOP
    rc = ESMF_SUCCESS
    do tile=1,LIS_rc%ntiles(nest)
      col = LIS_domain(nest)%tile(tile)%col
      row = LIS_domain(nest)%tile(tile)%row
      farrayLIS(tile) = farray(col,row)
    enddo
  end subroutine

  !-----------------------------------------------------------------------------

#undef METHOD
#define METHOD "LIS_FarrayR8CopyToLisFarrayR4"

  subroutine LIS_FarrayR8CopyToLisFarrayR4(farray,farrayLIS,nest,rc)
! !ARGUMENTS:
    real(ESMF_KIND_R8),intent(in),pointer    :: farray(:,:)
    real(ESMF_KIND_R4),intent(inout),pointer :: farrayLIS(:)
    integer,intent(in)                       :: nest
    integer,intent(out)                      :: rc
! !LOCAL VARIABLES:
    integer                         :: tile, col, row
! !DESCRIPTION:
!  This routine copies from a 2D array to an LIS 1D array
!EOP
    rc = ESMF_SUCCESS
    do tile=1,LIS_rc%ntiles(nest)
      col = LIS_domain(nest)%tile(tile)%col
      row = LIS_domain(nest)%tile(tile)%row
      farrayLIS(tile) = farray(col,row)
    enddo
  end subroutine

  !-----------------------------------------------------------------------------

#undef METHOD
#define METHOD "LIS_FarrayR4CopyToLisFarrayR4"

  subroutine LIS_FarrayR4CopyToLisFarrayR4(farray,farrayLIS,nest,rc)
! !ARGUMENTS:
    real(ESMF_KIND_R4),intent(in),pointer    :: farray(:,:)
    real(ESMF_KIND_R4),intent(inout),pointer :: farrayLIS(:)
    integer,intent(in)                       :: nest
    integer,intent(out)                      :: rc
! !LOCAL VARIABLES:
    integer                         :: tile, col, row
! !DESCRIPTION:
!  This routine copies from a 2D array to an LIS 1D array
!EOP
    rc = ESMF_SUCCESS
    do tile=1,LIS_rc%ntiles(nest)
      col = LIS_domain(nest)%tile(tile)%col
      row = LIS_domain(nest)%tile(tile)%row
      farrayLIS(tile) = farray(col,row)
    enddo
  end subroutine

  !-----------------------------------------------------------------------------

#undef METHOD
#define METHOD "LIS_FarrayR8CopyToLisFarrayR8"

  subroutine LIS_FarrayR8CopyToLisFarrayR8(farray,farrayLIS,nest,rc)
! !ARGUMENTS:
    real(ESMF_KIND_R8),intent(in),pointer    :: farray(:,:)
    real(ESMF_KIND_R8),intent(inout),pointer :: farrayLIS(:)
    integer,intent(in)                       :: nest
    integer,intent(out)                      :: rc
! !LOCAL VARIABLES:
    integer                         :: tile, col, row
! !DESCRIPTION:
!  This routine copies from a 2D array to an LIS 1D array
!EOP
    rc = ESMF_SUCCESS
    do tile=1,LIS_rc%ntiles(nest)
      col = LIS_domain(nest)%tile(tile)%col
      row = LIS_domain(nest)%tile(tile)%row
      farrayLIS(tile) = farray(col,row)
    enddo
  end subroutine

  !-----------------------------------------------------------------------------

#undef METHOD
#define METHOD "LIS_FarrayR4CopyToNoah_3_3"

  subroutine LIS_FarrayR4CopyToNoah_3_3(farray,stdName,nest,rc)
! !ARGUMENTS:
    real(ESMF_KIND_R4),intent(in),pointer       :: farray(:,:)
    character(*),intent(in)                     :: stdName
    integer,intent(in)                          :: nest
    integer,intent(out)                         :: rc
! !LOCAL VARIABLES:
    integer                         :: tile, col, row
! !DESCRIPTION:
!  This routine copies from a 2D array to an LIS 1D array
!EOP
    rc = ESMF_SUCCESS
    select case (trim(stdName))
        case ('liquid_fraction_of_soil_moisture_layer_1')
          do tile=1,LIS_rc%ntiles(nest)
            col = LIS_domain(nest)%tile(tile)%col
            row = LIS_domain(nest)%tile(tile)%row
            noah33_struc(nest)%noah(tile)%sh2o(1) = farray(col,row)
          enddo
        case ('liquid_fraction_of_soil_moisture_layer_2')
          do tile=1,LIS_rc%ntiles(nest)
            col = LIS_domain(nest)%tile(tile)%col
            row = LIS_domain(nest)%tile(tile)%row
            noah33_struc(nest)%noah(tile)%sh2o(2) = farray(col,row)
          enddo
        case ('liquid_fraction_of_soil_moisture_layer_3')
          do tile=1,LIS_rc%ntiles(nest)
            col = LIS_domain(nest)%tile(tile)%col
            row = LIS_domain(nest)%tile(tile)%row
            noah33_struc(nest)%noah(tile)%sh2o(3) = farray(col,row)
          enddo
        case ('liquid_fraction_of_soil_moisture_layer_4') 
          do tile=1,LIS_rc%ntiles(nest)
            col = LIS_domain(nest)%tile(tile)%col
            row = LIS_domain(nest)%tile(tile)%row
            noah33_struc(nest)%noah(tile)%sh2o(4) = farray(col,row)
          enddo
        case ('soil_moisture_fraction_layer_1')
          do tile=1,LIS_rc%ntiles(nest)
            col = LIS_domain(nest)%tile(tile)%col
            row = LIS_domain(nest)%tile(tile)%row
            noah33_struc(nest)%noah(tile)%smc(1) = farray(col,row)
          enddo
        case ('soil_moisture_fraction_layer_2')
          do tile=1,LIS_rc%ntiles(nest)
            col = LIS_domain(nest)%tile(tile)%col
            row = LIS_domain(nest)%tile(tile)%row
            noah33_struc(nest)%noah(tile)%smc(2) = farray(col,row)
          enddo
        case ('soil_moisture_fraction_layer_3')
          do tile=1,LIS_rc%ntiles(nest)
            col = LIS_domain(nest)%tile(tile)%col
            row = LIS_domain(nest)%tile(tile)%row
            noah33_struc(nest)%noah(tile)%smc(3) = farray(col,row)
          enddo
        case ('soil_moisture_fraction_layer_4')
          do tile=1,LIS_rc%ntiles(nest)
            col = LIS_domain(nest)%tile(tile)%col
            row = LIS_domain(nest)%tile(tile)%row
            noah33_struc(nest)%noah(tile)%smc(4) = farray(col,row)
          enddo
        case ('soil_temperature_layer_1')
          do tile=1,LIS_rc%ntiles(nest)
            col = LIS_domain(nest)%tile(tile)%col
            row = LIS_domain(nest)%tile(tile)%row
            noah33_struc(nest)%noah(tile)%stc(1) = farray(col,row)
          enddo
        case ('soil_temperature_layer_2')
          do tile=1,LIS_rc%ntiles(nest)
            col = LIS_domain(nest)%tile(tile)%col
            row = LIS_domain(nest)%tile(tile)%row
            noah33_struc(nest)%noah(tile)%stc(2) = farray(col,row)
          enddo
        case ('soil_temperature_layer_3')
          do tile=1,LIS_rc%ntiles(nest)
            col = LIS_domain(nest)%tile(tile)%col
            row = LIS_domain(nest)%tile(tile)%row
            noah33_struc(nest)%noah(tile)%stc(3) = farray(col,row)
          enddo
        case ('soil_temperature_layer_4')
          do tile=1,LIS_rc%ntiles(nest)
            col = LIS_domain(nest)%tile(tile)%col
            row = LIS_domain(nest)%tile(tile)%row
            noah33_struc(nest)%noah(tile)%stc(4) = farray(col,row)
          enddo
#ifdef WRF_HYDRO
        case ('surface_water_depth')
          do tile=1,LIS_rc%ntiles(nest)
            col = LIS_domain(nest)%tile(tile)%col
            row = LIS_domain(nest)%tile(tile)%row
            noah33_struc(nest)%noah(tile)%sfhead1rt = farray(col,row)
          enddo
#endif
        case default
          call ESMF_LogSetError(ESMF_RC_ARG_BAD, &
            msg="Cannot directly hookup to noah33 "//trim(stdName), &
            line=__LINE__, file=FILENAME, rcToReturn=rc)
          return  ! bail ou
      end select

  end subroutine

  !-----------------------------------------------------------------------------

#undef METHOD
#define METHOD "LIS_FarrayR8CopyToNoah_3_3"

  subroutine LIS_FarrayR8CopyToNoah_3_3(farray,stdName,nest,rc)
! !ARGUMENTS:
    real(ESMF_KIND_R8),intent(in),pointer       :: farray(:,:)
    character(*),intent(in)                     :: stdName
    integer,intent(in)                          :: nest
    integer,intent(out)                         :: rc
! !LOCAL VARIABLES:
    integer                         :: tile, col, row
! !DESCRIPTION:
!  This routine copies from a 2D array to an LIS 1D array
!EOP
    rc = ESMF_SUCCESS
    select case (trim(stdName))
        case ('liquid_fraction_of_soil_moisture_layer_1')
          do tile=1,LIS_rc%ntiles(nest)
            col = LIS_domain(nest)%tile(tile)%col
            row = LIS_domain(nest)%tile(tile)%row
            noah33_struc(nest)%noah(tile)%sh2o(1) = farray(col,row)
          enddo
        case ('liquid_fraction_of_soil_moisture_layer_2')
          do tile=1,LIS_rc%ntiles(nest)
            col = LIS_domain(nest)%tile(tile)%col
            row = LIS_domain(nest)%tile(tile)%row
            noah33_struc(nest)%noah(tile)%sh2o(2) = farray(col,row)
          enddo
        case ('liquid_fraction_of_soil_moisture_layer_3')
          do tile=1,LIS_rc%ntiles(nest)
            col = LIS_domain(nest)%tile(tile)%col
            row = LIS_domain(nest)%tile(tile)%row
            noah33_struc(nest)%noah(tile)%sh2o(3) = farray(col,row)
          enddo
        case ('liquid_fraction_of_soil_moisture_layer_4')
          do tile=1,LIS_rc%ntiles(nest)
            col = LIS_domain(nest)%tile(tile)%col
            row = LIS_domain(nest)%tile(tile)%row
            noah33_struc(nest)%noah(tile)%sh2o(4) = farray(col,row)
          enddo
        case ('soil_moisture_fraction_layer_1')
          do tile=1,LIS_rc%ntiles(nest)
            col = LIS_domain(nest)%tile(tile)%col
            row = LIS_domain(nest)%tile(tile)%row
            noah33_struc(nest)%noah(tile)%smc(1) = farray(col,row)
          enddo
        case ('soil_moisture_fraction_layer_2')
          do tile=1,LIS_rc%ntiles(nest)
            col = LIS_domain(nest)%tile(tile)%col
            row = LIS_domain(nest)%tile(tile)%row
            noah33_struc(nest)%noah(tile)%smc(2) = farray(col,row)
          enddo
        case ('soil_moisture_fraction_layer_3')
          do tile=1,LIS_rc%ntiles(nest)
            col = LIS_domain(nest)%tile(tile)%col
            row = LIS_domain(nest)%tile(tile)%row
            noah33_struc(nest)%noah(tile)%smc(3) = farray(col,row)
          enddo
        case ('soil_moisture_fraction_layer_4')
          do tile=1,LIS_rc%ntiles(nest)
            col = LIS_domain(nest)%tile(tile)%col
            row = LIS_domain(nest)%tile(tile)%row
            noah33_struc(nest)%noah(tile)%smc(4) = farray(col,row)
          enddo
        case ('soil_temperature_layer_1')
          do tile=1,LIS_rc%ntiles(nest)
            col = LIS_domain(nest)%tile(tile)%col
            row = LIS_domain(nest)%tile(tile)%row
            noah33_struc(nest)%noah(tile)%stc(1) = farray(col,row)
          enddo
        case ('soil_temperature_layer_2')
          do tile=1,LIS_rc%ntiles(nest)
            col = LIS_domain(nest)%tile(tile)%col
            row = LIS_domain(nest)%tile(tile)%row
            noah33_struc(nest)%noah(tile)%stc(2) = farray(col,row)
          enddo
        case ('soil_temperature_layer_3')
          do tile=1,LIS_rc%ntiles(nest)
            col = LIS_domain(nest)%tile(tile)%col
            row = LIS_domain(nest)%tile(tile)%row
            noah33_struc(nest)%noah(tile)%stc(3) = farray(col,row)
          enddo
        case ('soil_temperature_layer_4')
          do tile=1,LIS_rc%ntiles(nest)
            col = LIS_domain(nest)%tile(tile)%col
            row = LIS_domain(nest)%tile(tile)%row
            noah33_struc(nest)%noah(tile)%stc(4) = farray(col,row)
          enddo
        case default
          call ESMF_LogSetError(ESMF_RC_ARG_BAD, &
            msg="Cannot directly hookup to noah33 "//trim(stdName), &
            line=__LINE__, file=FILENAME, rcToReturn=rc)
          return  ! bail ou
      end select

  end subroutine

  !-----------------------------------------------------------------------------
  !-----------------------------------------------------------------------------

#undef METHOD
#define METHOD "LIS_FarrayI4CopyFromLisFarrayI4"

  subroutine LIS_FarrayI4CopyFromLisFarrayI4(farrayLIS,farray,nest,rc)
! !ARGUMENTS:
    integer(ESMF_KIND_I4),intent(in),pointer    :: farrayLIS(:)
    integer(ESMF_KIND_I4),intent(inout),pointer :: farray(:,:)
    integer,intent(in)                          :: nest
    integer,intent(out)                         :: rc
! !LOCAL VARIABLES:
    integer                         :: tile, col, row
! !DESCRIPTION:
!  This routine copies from an LIS 1D array to a 2D array
!EOP
    rc = ESMF_SUCCESS
    do row=1,LIS_rc%lnr(nest)
    do col=1,LIS_rc%lnc(nest)
      tile = LIS_domain(nest)%gindex(col,row)
      if(LIS_domain(nest)%gindex(col,row).ne.-1) then
        farray(col,row) = farrayLIS(tile)
      else
        farray(col,row) = MISSINGVALUE
      endif
    enddo
    enddo
  end subroutine

  !-----------------------------------------------------------------------------

#undef METHOD
#define METHOD "LIS_FarrayI8CopyFromLisFarrayI8"

  subroutine LIS_FarrayI8CopyFromLisFarrayI8(farrayLIS,farray,nest,rc)
! !ARGUMENTS:
    integer(ESMF_KIND_I8),intent(in),pointer    :: farrayLIS(:)
    integer(ESMF_KIND_I8),intent(inout),pointer :: farray(:,:)
    integer,intent(in)                          :: nest
    integer,intent(out)                         :: rc
! !LOCAL VARIABLES:
    integer                         :: tile, col, row
! !DESCRIPTION:
!  This routine copies from an LIS 1D array to a 2D array
!EOP
    rc = ESMF_SUCCESS
    do row=1,LIS_rc%lnr(nest)
    do col=1,LIS_rc%lnc(nest)
      tile = LIS_domain(nest)%gindex(col,row)
      if(LIS_domain(nest)%gindex(col,row).ne.-1) then
        farray(col,row) = farrayLIS(tile)
      else
        farray(col,row) = MISSINGVALUE
      endif
    enddo
    enddo
  end subroutine

  !-----------------------------------------------------------------------------

#undef METHOD
#define METHOD "LIS_FarrayR8CopyFromLisFarrayR4"

  subroutine LIS_FarrayR8CopyFromLisFarrayR4(farrayLIS,farray,nest,rc)
! !ARGUMENTS:
    real(ESMF_KIND_R4),intent(in),pointer       :: farrayLIS(:)
    real(ESMF_KIND_R8),intent(inout),pointer    :: farray(:,:)
    integer,intent(in)                          :: nest
    integer,intent(out)                         :: rc
! !LOCAL VARIABLES:
    integer                         :: tile, col, row
! !DESCRIPTION:
!  This routine copies from an LIS 1D array to a 2D array
!EOP
    rc = ESMF_SUCCESS
    do row=1,LIS_rc%lnr(nest)
    do col=1,LIS_rc%lnc(nest)
      tile = LIS_domain(nest)%gindex(col,row)
      if(LIS_domain(nest)%gindex(col,row).ne.-1) then
        farray(col,row) = farrayLIS(tile)
      else
        farray(col,row) = MISSINGVALUE
      endif
    enddo
    enddo
  end subroutine

  !-----------------------------------------------------------------------------

#undef METHOD
#define METHOD "LIS_FarrayR4CopyFromLisFarrayR4"

  subroutine LIS_FarrayR4CopyFromLisFarrayR4(farrayLIS,farray,nest,rc)
! !ARGUMENTS:
    real(ESMF_KIND_R4),intent(in),pointer       :: farrayLIS(:)
    real(ESMF_KIND_R4),intent(inout),pointer    :: farray(:,:)
    integer,intent(in)                          :: nest
    integer,intent(out)                         :: rc
! !LOCAL VARIABLES:
    integer                         :: tile, col, row
! !DESCRIPTION:
!  This routine copies from an LIS 1D array to a 2D array
!EOP
    rc = ESMF_SUCCESS
    do row=1,LIS_rc%lnr(nest)
    do col=1,LIS_rc%lnc(nest)
      tile = LIS_domain(nest)%gindex(col,row)
      if(LIS_domain(nest)%gindex(col,row).ne.-1) then
        farray(col,row) = farrayLIS(tile)
      else
        farray(col,row) = MISSINGVALUE
      endif
    enddo
    enddo
  end subroutine

  !-----------------------------------------------------------------------------

#undef METHOD
#define METHOD "LIS_FarrayR8CopyFromLisFarrayR8"

  subroutine LIS_FarrayR8CopyFromLisFarrayR8(farrayLIS,farray,nest,rc)
! !ARGUMENTS:
    real(ESMF_KIND_R8),intent(in),pointer       :: farrayLIS(:)
    real(ESMF_KIND_R8),intent(inout),pointer    :: farray(:,:)
    integer,intent(in)                          :: nest
    integer,intent(out)                         :: rc
! !LOCAL VARIABLES:
    integer                         :: tile, col, row
! !DESCRIPTION:
!  This routine copies from an LIS 1D array to a 2D array
!EOP
    rc = ESMF_SUCCESS
    do row=1,LIS_rc%lnr(nest)
    do col=1,LIS_rc%lnc(nest)
      tile = LIS_domain(nest)%gindex(col,row)
      if(LIS_domain(nest)%gindex(col,row).ne.-1) then
        farray(col,row) = farrayLIS(tile)
      else
        farray(col,row) = MISSINGVALUE
      endif
    enddo
    enddo
  end subroutine

end module
