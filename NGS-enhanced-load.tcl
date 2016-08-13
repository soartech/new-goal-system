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

variable soar_var_list ""

# Use this like C's #ifdef statements - the 'code' parameter only happens if 
# the soar variable named '$var_name' has been defined.
#
# Like in C and C++, frequent use of NGS_ifdef and NGS_ifndef will cause 
#   code readability issues and should be avoided.
#
# Example: NGS_ifdef varName "echo \"Hi my name is Fred\""

proc NGS_ifdef { var_name code } {

if [uplevel 1 "info exists $var_name" ] {
  uplevel 1 "$code"
  } else {
  return
  } 
}

# The inverse of NGS_ifdef.
# Same syntax and use - but code is only executed if the variable is NOT defined.

proc NGS_ifndef { var_name code } {
 
if [uplevel 1 "info exists $var_name" ] {
    return
  } else {
  uplevel 1 "$code"
  } 
}

# Use this like C's #ifeq statements - the 'code' parameter only happens if 
# the soar variable named '$var_name' has value equal to $check_val
#
# If the variable doesn't exist, $code won't be executed.

proc NGS_ifeq { var_name check_val code } {
   
  if [uplevel 1 "info exists $var_name" ] {
    if "[expr [string compare [uplevel 1 set $var_name] $check_val] == 0]" {
      uplevel 1 "$code" 
    }
  }
}

# Use this like C's #ifneq statements - the 'code' parameter only does NOT happen if 
# the soar variable named '$var_name' has value equal to $check_val
#
# If the variable doesn't exist, $code WILL be executed.

proc NGS_ifneq { var_name check_val code } {
   
  if [uplevel 1 "info exists $var_name" ] {
    if "[expr [string compare [uplevel 1 set $var_name] $check_val] != 0]" "uplevel 1 $code" 
  } else {
    uplevel 1 "$code"
  }
}


##!
# @brief Pull in all of the globally available variables 
#
# @devnote The variables come from NGS_create-soar-var

proc NGS_reference-soar-vars { } {
   variable soar_var_list
   foreach var $soar_var_list {
       uplevel 1 variable $var
   }
}

##!
# @brief Create a globally-avialable variable

proc NGS_create-soar-var { variable_name variable_value } {
   variable soar_var_list
   variable $variable_name
      
   if {[lsearch -exact $soar_var_list $variable_name ] == -1} {
     # echo "adding $variable_name to soar-var-list"
     lappend soar_var_list $variable_name
   } else {
     # echo "$variable_name already exists!"
     # do nothing 
   }
   
   # echo "Setting $variable_name to $variable_value"
   
   set "$variable_name" $variable_value
   
   # ... now reference the variable in our caller's context, too.
   uplevel 1 variable $variable_name
}

##
# Use this the way you would use bash's pushd
# 
# It will print out the usual "Loading files for,..." message
#
proc NGS_echo-pushd { directory } {
  
  NGS_ifndef NGS_NO_DEBUG_PRINTING "echo \"\n Loading files for [pwd]/$directory \n\""
  
  pushd $directory
}

##
# Use this the way you would use the standard Soar source
# 
# It will print out the usual " ... Loading file, ..." message
#
proc NGS_echo-source { file } {
  
  NGS_ifndef NGS_NO_DEBUG_PRINTING "echo \"\n ... Loading file: [pwd]/$file \n \""
  
  source $file
}

# Use this instead of the following:
#
# echo-pushd directory
# NGS_echo-source load.soar
# popd
#
proc NGS_load-soar-dir { directory } {
   
   NGS_echo-pushd $directory
    source "load.soar" 
   popd
}

## Use this to move to a particular directory and then load the "settings.tcl" file there.
## (Many settings.tcl files depend on the interpreter being in their home directory when they're loaded.)
proc NGS_load-settings { directory } {
  # if the directory to load from is the current directory, don't push/pop it -- older versions of jsoar don't like "." in the path when loading resources from a jar
  # this has since been fixed, so newer versions of jsoar would be fine without these ifs. Perhaps one day when we're confident no one is using old jsoar versions anymore
  # we can clean this up
  if { [string compare $directory "."] != 0 } {
    NGS_echo-pushd $directory
  }
  NGS_echo-source "settings.tcl"
  if { [string compare $directory "."] != 0 } {
    popd
  }
}
