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

# if NGS::version is already defined, don't do anything (NGS is already loaded)
if { [info exists NGS::version] == 0 } {
    package provide NGS 3.0

    # Utility TCL functions
    source scripts.tcl

    namespace eval NGS {

      echo "\nNow loading NGS"

      # enhanced file commands must use regular source
      source  "NGS-enhanced-load.tcl"

      # source the variables (must not use NGS_echo-source here)
      source standard-variables.tcl ;# Standard variables (same for other systems)

      # General NGS Settings
      NGS_load-settings .

      # Load NGS Core soar files

      # Infrastructure productions
      NGS_load-soar-dir infrastructure

      # this sets the version and also serves as the indictor that NGS has loaded
      set version 3.0

      ## Export the NGS tcl procedures so other namespaces can use them
      #### TODO: Go through and remove the NGS_ part of the name for procedures we should -not- export.
      namespace export NGS_*

      namespace export pterminatedgoals
      namespace export pactivegoals
      namespace export pdesiredgoals
      namespace export pallgoals
    }

    ## The following line is bad TCL form, but we're doing it anyway so our clients (Soar programmers) don't have to perform a lot of TCL namespace typing.
    namespace import NGS::NGS_*

    namespace import NGS::pterminatedgoals
    namespace import NGS::pactivegoals
    namespace import NGS::pdesiredgoals
    namespace import NGS::pallgoals

    echo "loaded NGS version $NGS::version"
} else {
    echo "warning: NGS version $NGS::version already loaded"
}