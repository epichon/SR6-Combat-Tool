//==============================================================================
//
//   DMRnd - the Mersenne Twister pseudo random generator in the ofc-library
//
//               Copyright (C) 2006  Dick van Oudheusden
//  
// This library is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public
// License as published by the Free Software Foundation; either
// version 2 of the License, or (at your option) any later version.
//
// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// General Public License for more details.
//
// You should have received a copy of the GNU General Public
// License along with this library; if not, write to the Free
// Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
//
//==============================================================================
// 
//  $Date: 2006/09/20 17:46:00 $ $Revision: 1.1 $
//
//==============================================================================

/*
 * This class is based on:
 * 
 *  Copyright (C) 1997 - 2002, Makoto Matsumoto and Takuji Nishimura,
 *  All rights reserved.                          
 *
 *  Redistribution and use in source and binary forms, with or without
 *  modification, are permitted provided that the following conditions
 *  are met:
 *
 *    1. Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *
 *    2. Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *
 *    3. The names of its contributors may not be used to endorse or promote 
 *       products derived from this software without specific prior written 
 *       permission.
 *
 *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
 *  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
 *  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
 *  A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 *  CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
 *  EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 *  PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 *  PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 *  LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
 *  NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 *  SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */

#include "DMRnd.h"

#include "warning.h"


#if _INTERFACE_

#include <stdint.h>

#include "config.h"

#include "DRandomable.h"



#define DMRD_N     (624)
#define DMRD_M     (397)

//
// The DMRnd class implements a pseudo random generator bases on the
// Mersenne Twister pseudo random generator. It is not only very fast,
// but it also passes the Marsaglia's 'Diehard' statistical tests and 
// it has a very long period of 2^19937 - 1.
//

@interface DMRnd : Object <DRandomable>
{
@private
  uint32_t _mt[DMRD_N];  // the state
  int      _mti;         // the index in state
}

#endif


#define DMRD_MAX        (4294967296.0)
#define DMRD_MASK       (0xffffffffUL)
#define DMRD_UPPER_MASK (0x80000000UL)  // most significant w-r bits 
#define DMRD_LOWER_MASK (0x7fffffffUL)  // least significant r bits 


@implementation DMRnd


const static uint32_t magic[] = { 0x0, 0x9908b0dfUL };


//// Constructors

//
// Initialise a non-seeded random generator
//
// @return the object
//

- (DMRnd *) init
{
  if (!(self = [super init])) return nil;

  [self seed :5489UL];
  
  return self;
}

//
// Initialise a seeded random generator
//
// @param seed     the seed to be used
// 
// @return the object
//

- (DMRnd *) init :(unsigned long) seed
{
  if (!(self = [super init])) return nil;
  
  [self seed :seed];
  
  return self;
}


//// Member methods

//
// Set the seed for the random generator
// 
// @param seed     the seed for the random generator
//
// @return the object
//

- (DMRnd *) seed :(unsigned long) seed
{
  _mt[0]= seed & DMRD_MASK;
  
  for (_mti = 1; _mti < DMRD_N; _mti++) 
  {
    _mt[_mti] = (1812433253UL * (_mt[_mti-1] ^ (_mt[_mti-1] >> 30)) + _mti);
    
    /* See Knuth TAOCP Vol2. 3rd Ed. P.106 for multiplier. */
    /* In the previous versions, MSBs of the seed affect   */
    /* only MSBs of the array _mt[].                       */
    /* 2002/01/09 modified by Makoto Matsumoto             */
    
    _mt[_mti] &= DMRD_MASK;        /* for >32 bit machines */
  }
  
  return self;
}


//// Random generator methods

//
// Get the next long (32 bit) from the generator
//  
// @return the next long
//

- (long) nextLong 
{
  return (long)((int32_t)[self _nextValue]);
}

//
// Get the next ranged long (32 bit) from the generator
// 
// @param from     the start of the range
// @param to       the end of the range
// 
// @return the next long
// 

- (long) nextLong :(long) from :(long) to
{
  return from + (to - from + 1) * ((double) [self _nextValue] / DMRD_MAX);
}

//
// Get the next integer (32 bit) from the generator
//  
// @return the next integer
//

- (int) nextInt
{
  return (int)[self _nextValue];
}

//
// Get the next ranged integer (32 bit) from the generator
// 
// @param from     the start of the range
// @param to       the end of the range
// 
// @return the next integer
// 

- (int) nextInt :(int) from :(int) to
{
  return from + (to - from + 1) * ((double) [self _nextValue] / DMRD_MAX);
}

//
// Get the next double from the generator (0 <= d < 1)
//  
// @return the next double
//

- (double) nextDouble
{
  return (double) [self _nextValue] / DMRD_MAX;
}

//
// Get the next double from the generator (from <= dE < to)
// 
// @param from     the start of the range
// @param to       the end of the range
// 
// @return the next double
// 

- (double) nextDouble :(double) from :(double) to
{
  return from + (to - from) * ((double)  [self _nextValue] / DMRD_MAX);
}


//// Private methods

//
// Get the next 32-bit value from the generator
// 
// @return the next 32-bit value
// 

- (uint32_t) _nextValue
{
  uint32_t y;

  if (_mti >= DMRD_N)  /* generate DMRD_N words at one time */
  {
    int kk;

    for (kk = 0; kk < DMRD_N-DMRD_M; kk++) 
    {
      y = (_mt[kk] & DMRD_UPPER_MASK) | (_mt[kk+1] & DMRD_LOWER_MASK );
      
      _mt[kk] = _mt[kk+DMRD_M] ^ (y >> 1) ^ magic[y & 0x1UL];
    }
    
    for (; kk < DMRD_N-1; kk++) 
    {
      y = (_mt[kk] & DMRD_UPPER_MASK) | (_mt[kk+1] & DMRD_LOWER_MASK);
      
      _mt[kk] = _mt[kk+(DMRD_M-DMRD_N)] ^ (y >> 1) ^ magic[y & 0x1UL];
    }
    
    y = (_mt[DMRD_N-1] & DMRD_UPPER_MASK) | (_mt[0] & DMRD_LOWER_MASK);
    
    _mt[DMRD_N-1] = _mt[DMRD_M-1] ^ (y >> 1) ^ magic[y & 0x1UL];

    _mti = 0;
  }
  
  y = _mt[_mti++];

  /* Tempering */
  y ^= (y >> 11);
  y ^= (y << 7) & 0x9d2c5680UL;
  y ^= (y << 15) & 0xefc60000UL;
  y ^= (y >> 18);

  return y;
}

@end

/*==========================================================================*/
