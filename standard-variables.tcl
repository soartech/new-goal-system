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

## since these definitions may vary per application,
## use macro expansion to define these universally

# echo "\n ... Loading file: [pwd]/standard-variables.tcl";
 
# top state quick links
NGS_create-soar-var top_state "top-state"

## Considerables (Generic term for any item that can be desired and activated - i.e. Goals, Transforms)

proc NGS_add_considerable_item_type { new_item_type } {
  
  variable soar_var_list
  
  variable considerable_categories
  variable considerable_item_types
  variable considerable_category
  variable considerable_item_type
  variable consideration_pool
  variable all_considerables
  variable any_considerable
  variable desired_considerables
  variable desired_considerable
  variable active_considerables
  variable active_considerable
  variable terminated_considerables
  variable terminated_considerable
  variable condition_categories
  variable any_condition
  
  # Initialize considerable_item_types if it's never been used before.
  if {[lsearch -exact $soar_var_list considerable_item_types ] == -1} {
    NGS_create-soar-var considerable_item_types ""
  }
  lappend considerable_item_types $new_item_type
  
  # Initialize considerable_categories if it's never been used before.
  if {[lsearch -exact $soar_var_list considerable_categories ] == -1} {
    NGS_create-soar-var considerable_categories ""
  }
  lappend considerable_categories [append new_item_type s] 

  NGS_create-soar-var considerable_category "{ <ngs_category> << $considerable_categories >> }"
  NGS_create-soar-var considerable_item_type "{ <ngs_considerable_type> << $considerable_item_types >> }"
  
  NGS_create-soar-var consideration_pool "{ <ngs_pool> << active desired terminated >> }"
  NGS_create-soar-var all_considerables "$considerable_category.$consideration_pool"
  NGS_create-soar-var any_considerable  "$all_considerables.$considerable_item_type"
  NGS_create-soar-var desired_considerables "$considerable_category.desired"
  NGS_create-soar-var desired_considerable "$desired_considerables.$considerable_item_type"
  NGS_create-soar-var active_considerables "$considerable_category.active"
  NGS_create-soar-var active_considerable "$active_considerables.$considerable_item_type"
  NGS_create-soar-var terminated_considerables "$considerable_category.terminated"
  NGS_create-soar-var terminated_considerable "$terminated_considerables.$considerable_item_type"
  
  NGS_create-soar-var condition_categories "{ <condition-category> << pre invariant satisfaction abort >> }"
  NGS_create-soar-var any_condition "$desired_considerable.conditions.$condition_categories"

}

NGS_add_considerable_item_type goal
NGS_add_considerable_item_type transform

## Goals
NGS_create-soar-var goals     "goals"
NGS_create-soar-var all_goals "$goals.$consideration_pool"
NGS_create-soar-var any_goal  "$all_goals.goal"
NGS_create-soar-var desired_goals "$goals.desired"
NGS_create-soar-var desired_goal  "$desired_goals.goal"
NGS_create-soar-var active_goals "$goals.active"
NGS_create-soar-var active_goal "$active_goals.goal"
NGS_create-soar-var terminated_goals "$goals.terminated"
NGS_create-soar-var terminated_goal  "$terminated_goals.goal"

# Basic IO
NGS_create-soar-var input_link "io.input-link"
NGS_create-soar-var output_link "io.output-link"

# Time links
NGS_create-soar-var sim_time "$input_link.sim-time"
NGS_create-soar-var cycle_count "$input_link.cycle-count"
NGS_create-soar-var real_time "$input_link.world-time"

# Master time is what the NGS native code works from.
NGS_create-soar-var master_time "$cycle_count" 

# Main Message Queue Links 

## 
# Special values used globally
NGS_create-soar-var NGS_STANDALONE *standalone*
NGS_create-soar-var NGS_UNKNOWN *unknown*

##########################################################
# Infrastructure use

NGS_create-soar-var soar_var_creation_counter 0

#################################################
# Debug printing configuration

# Level 0: nothing is output
# Level 1: program level traces output (what you really want to see to know status)
# Level 2: program debugging only
# Level 3: system level (e.g. operators, goals, etc) output
NGS_create-soar-var NGS_DLVL_SYSTEM 3
NGS_create-soar-var NGS_DLVL_PROG_DBG 2
NGS_create-soar-var NGS_DLVL_PROG_NORMAL 1
NGS_create-soar-var NGS_DLVL_NO_DBG 0

NGS_create-soar-var NGS_DEBUG_OUTPUT_LEVEL $NGS_DLVL_SYSTEM

NGS_create-soar-var NGS_DEBUG_INTERRUPT true
