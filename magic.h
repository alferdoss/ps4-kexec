#ifndef MAGIC_H
#define MAGIC_H

/*
 * Thin wrapper: maps legacy PS4_x_xx defines to the centralized
 * ps4-offsets submodule (__x_xx__ convention), then pulls in the
 * version-dispatched header.
 */

#if defined(PS4_3_55)
  #define __3_55__
#elif defined(PS4_3_70)
  #define __3_70__
#elif defined(PS4_4_00) || defined(PS4_4_01)
  /* 4.00 and 4.01 shared offsets in the old header */
  #if defined(PS4_4_01)
    #define __4_01__
  #else
    #define __4_00__
  #endif
#elif defined(PS4_4_05)
  #define __4_05__
#elif defined(PS4_4_55)
  #define __4_55__
#elif defined(PS4_5_01)
  #define __5_01__
#elif defined(PS4_5_05)
  #define __5_05__
#elif defined(PS4_6_72)
  #define __6_72__
#elif defined(PS4_9_00)
  #define __9_00__
#elif defined(PS4_9_03)
  #define __9_03__
#elif defined(PS4_11_00)
  #define __11_00__
#endif

#include "ps4-offsets/includes.h"

#endif /* MAGIC_H */
