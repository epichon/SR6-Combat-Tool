//==============================================================================
//
//            warning - the warning module in the ofc-library
//
//               Copyright (C) 2003  Dick van Oudheusden
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

#include "warning.h"

#include <stdio.h>

//
// 
// The warning module implements a function for warning invalid use of the library.
//
//

const char DW_UNKNOWN_WARNING[]    = "Unknown warning: %s";
const char DW_METHOD_NOT_ALLOWED[] = "Method [%s] not allowed";
const char DW_METHOD_NOT_IMPL[]    = "Method [%s] not implemented";
const char DW_INVALID_ARG[]        = "Invalid argument: %s";
const char DW_ARG_OUT_RANGE[]      = "Argument out of range: %s";
const char DW_ARG_NOT_CLASS[]      = "Argument is not a class: %s";
const char DW_INVALID_CLASS[]      = "Invalid class for argument: %s";
const char DW_INVALID_PROT[]       = "Invalid protocol for argument: %s";
const char DW_OBJECT_NOT_INIT[]    = "Object not initialized, use [%s]";
const char DW_NIL_NOT_ALLOWED[]    = "nil not allowed for argument: %s";
const char DW_MEMBER_ALREADY_SET[] = "Member [%s] is already set";
const char DW_UNEXPECTED_ERROR[]   = "Unexpected error: %s";
const char DW_PROT_NOT_IMPL[]      = "Argument does not implement protocol: %s";
const char DW_INVALID_PATTERN[]    = "Invalid regular expression: %s";
const char DW_INVALID_STATE[]      = "Invalid state, expecting: %s";
//
// Report a warning
//
// @param name     the name of the method/file
// @param line     the line number in the file
// @param warning  the warning 
// @param param    the parameter for the warning code
//

void warning(const char *name, int line, const char *warning, const char *param)
{
  fprintf(stderr, "%s(%d) : ", name, line);
  fprintf(stderr, warning, param);
  fputc  ('\n', stderr);
}

/*===========================================================================*/

