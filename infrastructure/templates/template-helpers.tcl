#
# Copyright (c) 2010, Soar Technology, Inc.
# All rights reserved.
# 
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
# 
# * Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.
# 
# * Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the
#   documentation and/or other materials provided with the distribution.
# 
# * Neither the name of Soar Technology, Inc. nor the names of its contributors
#   may be used to endorse or promote products derived from this software
#   without the specific prior written permission of Soar Technology, Inc.
# 
# THIS SOFTWARE IS PROVIDED BY SOAR TECHNOLOGY, INC. AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL SOAR TECHNOLOGY, INC. OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER 
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, 
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE 
# USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

#########################################################################################
## Helpers (can be ignored)

##
# Generates a unique name for use as a soar ID or TCL variable.

proc NGS_gen-soar-varname { { base "variable" } } {
   variable soar_var_creation_counter
   incr soar_var_creation_counter
   
   return "<$base-$soar_var_creation_counter>"
}

##
# This should not be called externally
# 
# This procedure creates a type list compatible with soar for use
#  in creating objects like goals, operators, and complex data structures
#
proc NGS_create-soar-type-list { type_list_param } {
  set type_list " "
  
  foreach type $type_list_param {
     set type_list "$type_list ^type $type\n "
  }

  return $type_list
}

##
# Used internally to create type structures under objects
#
proc NGS_create-type-structure-for-object { object_bind object_type_list} {
  set ti_var [NGS_gen-soar-varname "type-info"]
  set types_var [NGS_gen-soar-varname "types"]
  
  # Most Derived Type is always the _last_ item in the type list
  return "($object_bind  ^type-info $ti_var)
          ($ti_var       ^most-derived-type [lindex $object_type_list [expr [llength $object_type_list] - 1]]
                         ^all-types $types_var)
          ($types_var   [NGS_create-soar-type-list $object_type_list])"

}

