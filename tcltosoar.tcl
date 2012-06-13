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

#!/bin/sh
# The backslash makes the next line a comment in Tcl \
exec /usr/bin/tclsh "$0" ${1+"$@"}

################################################################################
################################################################################
################################################################################
################################################################################
# pushd/popd stuff copied here to keep everything in one file
global TCLXENV(dirPushList)

set TCLXENV(dirPushList) "\"[pwd]\""

rename cd tcl-cd
proc cd {{dir $env(HOME)}} {
   global env TCLXENV
   if [catch "tcl-cd \"$dir\"" msg] {
      return $msg
   } else {
      set fulldir [pwd]
         set TCLXENV(dirPushList) \
         [linsert [lrange $TCLXENV(dirPushList) 1 end] \
         0 "$fulldir"]
         return $fulldir	
   }
}

proc pushd {dir} {
   global TCLXENV

   if [catch "tcl-cd \"$dir\"" msg] {
      return $msg
   } else {
      set dir [pwd]
         set TCLXENV(dirPushList) [linsert $TCLXENV(dirPushList) 0 "$dir"]
         return $dir
   }
}

proc popd {} {
   global TCLXENV

   if {[llength $TCLXENV(dirPushList)] > 1} {
      set prev_dir [lindex $TCLXENV(dirPushList) 1]
         set TCLXENV(dirPushList) [lrange $TCLXENV(dirPushList) 1 end]
         if [catch "tcl-cd \"$prev_dir\"" msg] {
            return $msg
         } else {
            return $prev_dir
         }
   } else {
      error "directory stack cannot be empty"
   }
}

proc topd {} {
   global TCLXENV
   return [lindex $TCLXENV(dirPushList) 0]
}

proc dirs {} { 
   global TCLXENV
   return $TCLXENV(dirPushList)
}

################################################################################
################################################################################
################################################################################
################################################################################
# REAL CODE STARTS HERE
set inputFile {}

proc printUsage { } {
   puts "TclToSoar Compiler, (c) 2006 Soar Technology, Inc."
   puts ""
   puts "Usage: tcltosoar.tcl <inputfile>"
   puts ""
   puts "Reads input file, processing Tcl commands. Writes resulting"
   puts "Tcl-free Soar code to standard output."
}

proc processArgs { } {
   global argv
   global inputFile

   set nargs [llength $argv]
   if { $nargs == 1 } {
      set inputFile [lindex $argv 0]
   } else {
      puts stderr "Incorrect number of arguments."
      exit 1   
   }
}

# Try to process args before we rename exit and friends..
processArgs

# Save the original puts so that we can print puts commands out to
# file without an infinite loop
rename puts putsInternal
rename exit exitInternal

##
# Takes a command name and argument list and prints the command
# and arguments out
proc echoCommand { name args } { putsInternal "$name $args;\n" }

proc ignoreCommand { name args } { putsInternal "# ignored $name;\n" }

##
# Map all the command names in names to echoCommand
proc echoCommands { names } {
   foreach name $names {
      interp alias {} $name {} echoCommand $name
   }
}

##
# Map all the command names in names to ignoreCommand
proc ignoreCommands { names } {
   foreach name $names {
      interp alias {} $name {} ignoreCommand $name
   }
}

# This is the list of Soar commands to preserve in the output
echoCommands {
   puts
   soarnews
   version
   exit
   quit
   log
   matches
   production-find
   preferences
   print
   run
   stop-soar
   watch
   gds_print
   new-agent
   add-wme
   ask
   attention-lapse
   start-attention-lapse
   wake-from-attention-lapse
   attribute-preferences-mode
   capture-input
   chunk-name-format
   default-wme-depth
   echo
   excise
   explain-backtraces
   firing-counts
   format-watch
   indifferent-selection
   init-soar
   input-period
   internal-symbols
   io
   learn
   log
   matches
   max-chunks
   max-elaborations
   max-nil-output-cycles
   memories
   monitor
   multi-attributes
   o-support-mode
   production-find
   preferences
   print
   pwatch
   quit
   replay-input
   remove-wme
   rete-net
   run
   sp
   stats
   stop-soar
   warnings
   watch
   gds_print
   verbose
   soar8
   waitsnc
   new-agent
   set-default-depth
   set-visible
}

# This is a list of Soar commands that depend on Tcl that should be removed 
# from the final output
ignoreCommands {
   output-strings-destination
}

# Process command-line arge
processArgs

# Read the input file
source $inputFile

# Exit
exitInternal 0

