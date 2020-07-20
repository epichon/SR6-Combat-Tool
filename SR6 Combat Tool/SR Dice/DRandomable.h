#ifndef _DRANDOMABLE_H
#define _DRANDOMABLE_H

//==============================================================================
//
//     DRandomable - the protocol for pseudo random generator classes 
//
//               Copyright (C) 2003  Dick van Oudheusden
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
//  $Date: 2003/11/22 06:23:02 $ $Revision: 1.1 $
//
//==============================================================================

// The DRandomable protocol specifies methods for classes that implements
// pseudo random generators.


@protocol DRandomable

//
// Set the seed for the random generator
// 
// @param seed     the seed for the random generator
//
// @return the object
//

- seed :(unsigned long) seed;

//
// Get the next long from the generator
//  
// @return the next long
//

- (long) nextLong;

//
// Get the next long inside a range from the generator
// 
// @param from     the start of the range
// @param to       the end of the range
// 
// @return the next long
// 

- (long) nextLong :(long) from :(long) to;

//
// Get the next integer from the generator
//  
// @return the next integer
//

- (int) nextInt;

//
// Get the next integer inside a range from the generator
// 
// @param from     the start of the range
// @param to       the end of the range
// 
// @return the next integer (inside the range)
// 

- (int) nextInt :(int) from :(int) to;

//
// Get the next double from the generator (0 <= v < 1)
//  
// @return the next double
//

- (double) nextDouble;

//
// Get the next double from the generator (from <= v < to)
// 
// @param from     the start of the range
// @param to       the end of the range
// 
// @return the next double
// 

- (double) nextDouble :(double) from :(double) to;

@end

#endif

