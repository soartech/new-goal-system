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
## Manipulators

proc NGS_name { object name } {
  return "($object ^name $name)"
}

# Use to create an object with tags and a type
#
# e.g. [NGS_create-object <missions> mission adjust-fire]

proc NGS_create-object { owner_object attribute object_type_list object_bind 
                         {tags_bind ""} } {

  set ti_var [NGS_gen-soar-varname "type-info"]
  set types_var [NGS_gen-soar-varname "types"]

  # Default value initialization
  if {$tags_bind == ""} {set tags_bind [NGS_gen-soar-varname "new-condition"]}

  
  return "($owner_object ^$attribute $object_bind) 
          ($object_bind  ^tags $tags_bind)
          [NGS_create-type-structure-for-object $object_bind $object_type_list]"
}

# Create an object which the system treats as a "considerable" - 
# that is, it's subject to activation rules and conditions.
#
# Has tags and a type hierarchy list (with more abstract types coming earlier in the list, 
# and the last item being the most derived type.
#
# this one is more complex with a conditions attribute; to create the
# base structure, calls the *simple* version above first.

proc NGS_create-considerable { considerable_category 
                               considerable_pool 
                               considerable_type_list
                               {considerable_bind ""} 
                               {tags_bind ""} 
                               {conditions_bind ""} } {       

  # Default value initialization
  if {$considerable_bind == ""} {set considerable_bind [NGS_gen-soar-varname "new-considerable"]}
  if {$tags_bind == ""} {set tags_bind [NGS_gen-soar-varname "new-considerable-tags"]}
  if {$conditions_bind == ""} {set conditions_bind [NGS_gen-soar-varname "new-considerable-conditions"]}
                                                       
  return "($considerable_pool ^$considerable_category $considerable_bind)
          ($considerable_bind ^tags $tags_bind)
          ($considerable_bind ^conditions $conditions_bind)
          [NGS_create-type-structure-for-object $considerable_bind $considerable_type_list]"
}


# Create a simple goal with just tags and a type list 
# (and conditions come for free -- required for considerable mgmt at this time

proc NGS_create-goal {goal_pool goal_type_list 
					 {goal_bind ""} 
				  	 {tags_bind ""} } {

  NGS_reference-soar-vars
  
  # Default value initialization
  if {$goal_bind == ""} {set goal_bind [NGS_gen-soar-varname "new-goal"]}
  if {$tags_bind == ""} {set tags_bind [NGS_gen-soar-varname "new-goal-tags"]}
								  								  
  return "[NGS_create-considerable goal $goal_pool [concat goal $goal_type_list] $goal_bind $tags_bind]"
}

##!
# @brief Create a simple goal as a subgoal of another previously created super goal (super_bind)
# essentially same as NGS_create-goal, but also adds a subgoal relationship with parent
#
# @devnote ONLY creates a simple goal.  CANNOT be used to create achievement goals, maintenance goals, etc.
#          If you want to do that, use the add-subgoal mechanism with creation
#          in two steps.

proc NGS_create-subgoal {goal_pool goal_type_list super_bind
					    {goal_bind ""} 
				     	{tags_bind ""} } {

  NGS_reference-soar-vars
  
  # Default value initialization
  if {$goal_bind == ""} {set goal_bind [NGS_gen-soar-varname "new-goal"]}
  if {$tags_bind == ""} {set tags_bind [NGS_gen-soar-varname "new-goal-tags"]}
								  								  
  return "[NGS_create-considerable goal $goal_pool [concat goal $goal_type_list] $goal_bind $tags_bind]
          [NGS_add-subgoal $super_bind $goal_bind]"
}

# Turn a pre-existing goal into a subgoal of another goal.
#
# @devnote ngs*top-state*elaborate*subgoal will supply the complementary 
#          $super_bind ^subgoal $sub_bind for us -- but ONLY when the subgoal
#          is in one of the goals pools.  This is by design, to facilitate 
#          automatic cleanup when a goal is removed from the terminated pool.

proc NGS_add-subgoal { super_bind sub_bind } {
  return "($sub_bind ^parent-goal $super_bind)"
}


# Use to propose an operator (directly from a goal, no transform)
#
# e.g. [NGS_create-operator create-adjust-fire-mission <g>]

proc NGS_create-operator { operator_type_list goal_id 
                         {operator_bind "<o>"} 
                         {operator_pref_list "+ ="} 
                         {state "<s>"} } {

  NGS_reference-soar-vars
  
  set most_derived_operator_type [lindex $operator_type_list [expr [llength $operator_type_list] - 1]]
  
  return "($state ^operator $operator_bind $operator_pref_list) 
          ($operator_bind ^name $most_derived_operator_type
                          ^goal $goal_id)
          [NGS_create-type-structure-for-object $operator_bind [concat operator $operator_type_list]]"
}


#
# Create a production which will, when triggered, add a simple binary preference between two operators
#
# (with optional additional tests on the operators)
#
#  e.g., NGS_prefer-operator-x-over-y <opname1> <opname2>
#
# @devnote no NGS_reference-soar-vars here -- but could be added later if needed.

proc NGS_prefer-operator-x-over-y { op1name op2name 
                                  {op1test ""} 
                                  {op2test ""} 
                                  {prod_prefix "operator-preference"}} {
   sp "$prod_prefix*$op1name*$op2name*[gensymid]
         (state <s> ^operator <o1> + {<> <o1> <o2>} +)
         (<o1> ^name $op1name)
         (<o2> ^name $op2name)
         $op1test
         $op2test
   -->
         (<s> ^operator <o1> > <o2>)"
}


#
# add a tag to the given 'tags' structure.
#
 
proc NGS_tag {tags_bind tag_name tag_value} {
  return "($tags_bind ^$tag_name $tag_value)"
}

##########################################################################
# Marking standard goal information (achieved, unachievable, suspended or active)


proc NGS_mark-active { tags_bind } { 
   return "($tags_bind ^active *yes*)"
}

proc NGS_unmark-active { tags_bind } { 
   return "($tags_bind ^active *yes* -)"
}

proc NGS_mark-suspended { tags_bind } { 
   return "($tags_bind ^suspended *yes*)"
}

proc NGS_unmark-suspended { tags_bind } { 
   return "($tags_bind ^suspended *yes* -)"
}

proc NGS_mark-achieved { tags_bind } { 
   return "($tags_bind ^achieved *yes*)"
}

proc NGS_unmark-achieved { tags_bind } { 
   return "($tags_bind ^achieved *yes* -)"
}

proc NGS_mark-unachievable { tags_bind } { 
   return "($tags_bind ^unachievable *yes*)"
}

proc NGS_unmark-unachievable { tags_bind } { 
   return "($tags_bind ^unachievable *yes* -)"
}