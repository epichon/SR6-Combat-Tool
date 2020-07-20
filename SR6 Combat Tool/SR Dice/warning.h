#ifndef _WARNING_H
#define _WARNING_H

//==============================================================================
//
//            warning - the warning module in the ofc-library
//
//               Copyright (C) 2002  Dick van Oudheusden
//  
// This program is free software; you can redistribute it and/or
// modify it under the terms of the GNU General Public
// License as published by the Free Software Foundation; either
// version 2 of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// General Public License for more details.
//
// You should have received a copy of the GNU General Public
// License along with this program; if not, write to the Free
// Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
//
//==============================================================================
// 
//  $Date: 2004/10/12 05:04:21 $ $Revision: 1.5 $
//==============================================================================

// The warning module implements a function for warning invalid use of the library

extern const char DW_UNKNOWN_WARNING[];    // param: anything
extern const char DW_METHOD_NOT_ALLOWED[]; // param: method name
extern const char DW_METHOD_NOT_IMPL[];    // param: method
extern const char DW_INVALID_ARG[];        // param: argument
extern const char DW_ARG_OUT_RANGE[];      // param: argument
extern const char DW_ARG_NOT_CLASS[];      // param: argument
extern const char DW_INVALID_CLASS[];      // param: argument
extern const char DW_INVALID_PROT[];       // param: argument
extern const char DW_OBJECT_NOT_INIT[];    // param: method
extern const char DW_NIL_NOT_ALLOWED[];    // param: argument
extern const char DW_MEMBER_ALREADY_SET[]; // param: member
extern const char DW_UNEXPECTED_ERROR[];   // param: extra info
extern const char DW_PROT_NOT_IMPL[];      // param: protocol
extern const char DW_INVALID_PATTERN[];    // param: msg
extern const char DW_INVALID_STATE[];      // param: expected state
//
// Report a warning
//
// @param name     the name of the method/file
// @param line     the line number in the file
// @param warning  the warning
// @param param    the parameter for the warning code
// 

extern void warning(const char *name, int line, const char *warning, const char *param);

#endif

