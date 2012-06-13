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

This is the "New Goal System", version 3.0

NGS provides Tcl macros to help with basic goal management.

See the file "documentation/NGS User Guide.pdf" for an overview of NGS capabilities.

To use NGS, use these steps:

1. Copy and paste the following code into your Soar agent's source, customizing file names and directories as necessary:

#------------------------

# Change the following line to be the NewGoalSystem home directory.
#   (relative location is fine)
cd /mycode/NewGoalSystem
 
source NewGoalSystem.tcl

# Change the following line to be your code's home directory.
#   (relative loc. still o.k.)
cd /mycode/mySoarAgent

#------------------------

2. Source your agent in a manner that supports Tcl
2a: JSoar: Add the following VM argument when you run Java: -Djsoar.agent.interpreter=tcl
2b: CSoar: Run the script tcltosoar.tcl to expand the Tcl macros and output Tcl-free Soar code.
           You will need a copy of Tcl (freely available online)
           Run this command: tcltosoar.tcl <inputfile>
           You will probably want to redirect the output to a file
           Example: from the testing directory, run: tclsh ../tcltosoar.tcl water-jug-lite.soar > water-jug-lite-no-tcl.soar