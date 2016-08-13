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

# TODO go through and remove items from here that are no longer relevant.

# Use to test an object for a type
#
# e.g. [NGS_is-type <mission> adjust-fire]
#
proc NGS_is-type { object_id type_name } {
  return "($object_id ^type-info.all-types.type $type_name)"
}

# Use to test an object for a type
#
# e.g. [NGS_is-not-type <mission> adjust-fire]
#
proc NGS_is-not-type { object_id type_name } {
  return "-{
            ($object_id ^type-info.all-types.type $type_name)
           }"
}

# Use to test an object for a most derived type
#
# e.g. [NGS_is-most-derived-type <mission> adjust-fire]
#
proc NGS_is-most-derived-type { object_id type_name } {
  return "($object_id ^type-info.most-derived-type $type_name)"
}

# Use to test an object for not having a specific most derived type
#
# e.g. [NGS_is-not-most-derived-type <mission> adjust-fire]
#
proc NGS_is-not-most-derived-type { object_id type_name } {
  return "($object_id ^type-info.most-derived-type <> $type_name)"
}

# Use to test an object (usually operators) for a name
#
# e.g. [NGS_is-named <o> send-message]
#
proc NGS_is-named { object_id name } {
  return "($object_id ^name $name)"
}

# Use to test an object for a tag
#
# e.g. [NGS_is-tagged <mission> completed *yes*]
#
proc NGS_is-tagged { object_id tag_name {tag_val "" } } {
  return "($object_id ^tags.$tag_name $tag_val)"
}

# Use to test an object for the lack of a tag
#
# e.g. [NGS_is-not-tagged <mission> completed]
#
proc NGS_is-not-tagged { object_id tag_name {tag_val "" } } {
  return "-{
             ($object_id ^tags.$tag_name $tag_val)
           }"
}

########################################################
## Goal states (normally don't need to test this way, but sometimes need to)
########################################################

# Use to find out if a goal is active or not
#
# e.g. [NGS_is-not-active <goal>]

proc NGS_is-active { considerable_bind } {
   return "($considerable_bind ^tags.active *yes*)"
}

proc NGS_is-not-active { considerable_bind } {
  return "-{ [NGS_is-active $considerable_bind] }"
}

# Use to find out if a goal is suspended or not
#
# e.g. [NGS_is-not-suspended <goal>]

proc NGS_is-suspended { considerable_bind } {
   return "($considerable_bind ^tags.suspended *yes*)"
}

proc NGS_is-not-suspended { considerable_bind } {
  return "[NGS_is-not-tagged $considerable_bind suspended *yes*]"
}

# Use to find out if a goal is achieved or not
#
# e.g. [NGS_is-achieved <goal>]
#

proc NGS_is-achieved { considerable_bind } {
   return "($considerable_bind ^tags.achieved *yes*)"
}

proc NGS_is-not-achieved { considerable_bind } {
  return "[NGS_is-not-tagged $considerable_bind achieved *yes*]"
}

# Use to find out if a goal is unachievable
#
# e.g. [NGS_is-unachievable <goal>]
#

proc NGS_is-unachievable { considerable_bind } {
   return "($considerable_bind ^tags.unachievable *yes*)"
}

proc NGS_is-not-unachievable { considerable_bind } {
  return "[NGS_is-not-tagged $considerable_bind unachievable *yes*]"
}

########################################################
##
########################################################
# NOTE: right now it is very hard to test for "not parent-goal" and "not subgoal"

# Use to bind to a goal's parent-goal
#
# e.g. [NGS_is-parent-goal <goal> <potential-parent-goal>]
#
proc NGS_is-parent-goal { goal supergoal {supergoal_type ""} } {

  if { $supergoal_type != "" } {
    set supergoal_type_line "[NGS_is-type $supergoal $supergoal_type]"
  } else {
    set supergoal_type_line ""
  }

  return "($goal ^parent-goal $supergoal)
          $supergoal_type_line"
}

# Use to bind to a goal's subgoal
#
# e.g. [NGS_is-subgoal <goal> <potential-subgoal> ]
#
proc NGS_is-subgoal { goal subgoal {subgoal_type ""} } {

  if { $subgoal_type != "" } {
    set subgoal_type_line "[NGS_is-type $subgoal $subgoal_type]"
  } else {
    set subgoal_type_line ""
  }

  return "($goal ^subgoal $subgoal)
          $subgoal_type_line"
}

# Use to start a production to create a new goal
# (binds to the NGS desired goals section
#
# e.g. sp "my-production
#         [NGS_match-goalpool <goal-list> <s>]
#         -->
#         [NGS_create-achievement-goal <goal-list> ... ]
#
proc NGS_match-goalpool { goal_list {state_bind <s>} } {
  variable desired_goals
  return "(state $state_bind ^superstate nil
                             ^$desired_goals $goal_list)"
}

#
# Match to a named subgoal for a given goal.
#
# e.g., sp "my-production
#          [NGS_match-active-goal my-goal <my-goal>]
#          [NGS_match-subgoal <parentg> sub-name <sg-goal>]
#        --> ..."
#
proc NGS_match-subgoal { pgoal_bind subgoal_name { subgoal_bind ""} } {

  if {$subgoal_bind == ""} {set subgoal_bind [NGS_gen-soar-varname "subgoal"]}
  
    return "($pgoal_bind ^subgoal $subgoal_bind)
            [NGS_is-most-derived-type $subgoal_bind $subgoal_name]"
}

# start a production to bind to an active goal with a given most derived type
#
# e.g. sp "my-production
#          [NGS_match-active-goal myGoalType <goal-bind> ]
#          -->
#          ...do something...
#
# @devnote There's a slight danger of conflict here in using the hardcoded "<s>" as the state's ID - 
#          but <s> is such a convention in the soar community that it's unlikely to be 
#          anything else.

proc NGS_match-active-goal { goal_type 
                               {goal_bind ""} 
                               {state_bind <s>} } {
  variable active_goal

  # Default value initialization
  if {$goal_bind == ""} {set goal_bind [NGS_gen-soar-varname "bound-goal"]}

  return "(state $state_bind ^superstate   nil
                             ^$active_goal $goal_bind)
          [NGS_is-most-derived-type $goal_bind $goal_type]"

#                            ^$all_goals   $goal_list  <-- this LHS condition was causing too many matches (BSS)
}

# start a production to bind to a desired goal with a given most derived type
#
# e.g. sp "my-production
#          [NGS_match-desired-goal myGoalType <goal-list> ]
#          -->
#          ...do something...
#
# @devnote There's a slight danger of conflict here in using the hardcoded "<s>" as the state's ID - 
#          but <s> is such a convention in the soar community that it's unlikely to be 
#          anything else.

proc NGS_match-desired-goal { goal_type 
                                {goal_bind ""} 
                                {state_bind <s>} } {
  variable desired_goal

  # Default value initialization
  if {$goal_bind == ""} {set goal_bind [NGS_gen-soar-varname "bound-goal"]}

  return "(state $state_bind ^superstate   nil
                             ^$desired_goal $goal_bind)
          [NGS_is-most-derived-type $goal_bind $goal_type]"
}

# start a production to bind to a terminated goal with a given most derived type
#
# e.g. sp "my-production
#          [NGS_match-terminated-goal myGoalType <goal-list> ]
#          -->
#          ...do something...
#
# @devnote There's a slight danger of conflict here in using the hardcoded "<s>" as the state's ID - 
#          but <s> is such a convention in the soar community that it's unlikely to be 
#          anything else.

proc NGS_match-terminated-goal { goal_type 
                                   {goal_bind ""} 
                                   {state_bind <s>} } {
  variable terminated_goal

  # Default value initialization
  if {$goal_bind == ""} {set goal_bind [NGS_gen-soar-varname "bound-goal"]}

  return "(state $state_bind ^superstate   nil
                             ^$terminated_goal $goal_bind)
          [NGS_is-most-derived-type $goal_bind $goal_type]"
}

#
# create a condition that matches when there's no active goal of the given type
#
# e.g. sp "my-production
#         [NGS_no-active-goal <goal-name>]
#      -->
#         ...
#
# @devnote There's a slight danger of conflict here in using the hardcoded "<s>" as the state's ID - 
#          but <s> is such a convention in the soar community that it's unlikely to be 
#          anything else.

proc NGS_no-active-goal { goal_type  
                          {state_bind <s>} } {
   variable active_goal

  return "(state $state_bind -^$active_goal.type-info.most-derived-type $goal_type)"
}

# get a binding to the tags on an object.
#
# Use for productions that change the achieve, suspended,
#  unachievable state of a goal
#
# e.g. sp "my-production
#         [NGS_match-tags <goal> <gtags>]
#         -->
#         [NGS_tag <gtags> newtag newvalue]
#
proc NGS_match-tags { object obj_tags } {
  return "($object ^tags $obj_tags)"
}

# Return the bindings for a proposed-but-not-necessarily-selected operator
#
# e.g., sp "my-production
#          [NGS_match-proposed-operator <myoperator>]
#          ...
#
# @devnote There's a slight danger of conflict here in using the hardcoded "<s>" as the state's ID - 
#          but <s> is such a convention in the soar community that it's unlikely to be 
#          anything else.

proc NGS_match-proposed-operator { operator1_name 
                                     {op1_bind ""} 
                                     {state_bind <s>}} {
  # Default value initialization
  if {$op1_bind == ""} {set op1_bind [NGS_gen-soar-varname "operator-1"]}

   return "(state $state_bind ^operator $op1_bind +)
           ($op1_bind ^name $operator1_name)"
}

# Return the bindings for two proposed-but-not-necessarily-selected operators
#
# e.g., sp "my-production
#          [NGS_match-two-proposed-operators myoperator1 myoperator2]
#          ...
#
# @devnote There's a slight danger of conflict here in using the hardcoded "<s>" as the state's ID - 
#          but <s> is such a convention in the soar community that it's unlikely to be 
#          anything else.

proc NGS_match-two-proposed-operators { operator1_name operator2_name 
                                          {op1_bind ""} 
                                          {op2_bind ""} 
                                          {state_bind <s>}} {

   # Default value initialization
   if {$op1_bind == ""} {set op1_bind [NGS_gen-soar-varname "bound-operator"]}
   if {$op2_bind == ""} {set op2_bind [NGS_gen-soar-varname "bound-operator"]}

   return "(state $state_bind ^operator $op1_bind + $op2_bind +)
           ($op1_bind ^name $operator1_name)
           ($op2_bind ^name $operator2_name)"
}

# Match two operators with associated goals (by reference)
#
# e.g. sp "my-production
#         [NGS_match-two-operators-with-goals <o1> <o2> o1-type o2-type <og1> <og2> <s>]
#         -->
#         (<s> ^operator <o1> > <o2>)"
#
# @devnote There's a slight danger of conflict here in using the hardcoded "<s>" as the state's ID - 
#          but <s> is such a convention in the soar community that it's unlikely to be 
#          anything else.

proc NGS_match-two-operators-with-goals { op_bind1 op_bind2 
                                      {op_name1 ""} 
                                      {op_name2 ""} 
                                      {op_goal1 ""} 
                                      {op_goal2 ""}
                                      {state_bind "<s>"} } {

  if {$op_name1 == ""} { set ot_line1 "" } else { set ot_line1 "[NGS_is-named $op_bind1 $op_name1]" }
  if {$op_name2 == ""} { set ot_line2 "" } else { set ot_line2 "[NGS_is-named $op_bind2 $op_name2]" }
  if {$op_goal1 == ""} { set og_line1 "" } else { set og_line1 "($op_bind1 ^goal $op_goal1)" }
  if {$op_goal2 == ""} { set og_line2 "" } else { set og_line2 "($op_bind2 ^goal $op_goal2)" }

  return "(state $state_bind ^operator $op_bind1 +
                             ^operator $op_bind2 +)
          $ot_line1
          $ot_line2
          $og_line1
          $og_line2"
}

# Use start a production to apply an operator
#
# e.g. sp "my-production
#         [NGS_operator-application MyOperator <o> <og> <og-tags> <s>]
#
# @devnote There's a slight danger of conflict here in using the hardcoded "<s>" as the state's ID - 
#          but <s> is such a convention in the soar community that it's unlikely to be 
#          anything else.

proc NGS_match-operator {operator_name 
                                {operator_bind ""} 
                                {goal_bind ""} 
                                {goal_tags_bind ""} 
                                {state_bind "<s>"} } {

  # Default value initialization
  if {$operator_bind == ""} {set operator_bind [NGS_gen-soar-varname "operator"]}
  if {$goal_bind == ""} {set goal_bind [NGS_gen-soar-varname "goal"]}
  if {$goal_tags_bind == ""} {set goal_tags_bind [NGS_gen-soar-varname "goal-tags"]}

  return "(state $state_bind ^operator $operator_bind)
          ($operator_bind ^name $operator_name
                          ^goal $goal_bind)
          ($goal_bind     ^tags $goal_tags_bind)"
}

# Use start a production to create a goal in an operator application
#
# e.g. sp "my-production
#         [NGS_match-operator-for-create-goal <goal-list> MyOperator <o> <og> <og-tags> <s>]
#
# @devnote There's a slight danger of conflict here in using the hardcoded "<s>" as the state's ID - 
#          but <s> is such a convention in the soar community that it's unlikely to be 
#          anything else.

proc NGS_match-operator-for-create-goal {goal_list operator_name 
                                             {operator_bind ""} 
                                             {goal_bind ""} 
                                             {goal_tags_bind ""} 
                                             {state_bind "<s>"} } {
  variable desired_goals

  # Default value initialization
  if {$operator_bind == ""} {set operator_bind [NGS_gen-soar-varname "operator"]}
  if {$goal_bind == ""} {set goal_bind [NGS_gen-soar-varname "goal"]}
  if {$goal_tags_bind == ""} {set goal_tags_bind [NGS_gen-soar-varname "goal-tags"]}

  return "(state $state_bind  ^$desired_goals $goal_list
                              ^operator $operator_bind)
          ($operator_bind     ^name $operator_name
                              ^goal $goal_bind)
          ($goal_bind         ^tags $goal_tags_bind)"
}


############################################################
# test attribute sets

proc NGS_is-exactly-one { obj_id set_attribute set_item_attribute test_condition } {
  return "($obj_id ^$set_attribute.$set_item_attribute <obj1>)
          [eval $test_condition <obj1>]
          -{
             ($obj_id ^$set_attribute.$set_item_attribute { <obj2> <> <obj1> } )
             [eval $test_condition <obj2>]
           }
}

proc NGS_is-more-than-one { obj_id set_attribute set_item_attribute test_condition } {
  return "($obj_id ^$set_attribute.$set_item_attribute <obj1>)
          [eval $test_condition <obj1>]
          ($obj_id ^$set_attribute.$set_item_attribute { <obj2> <> <obj1> } )
          [eval $test_condition <obj2>]
}

# This should match in the case that we have one or more (obj ^attr ^test) matches,
# but should not produce a multimatch causing multiple rule firings.
proc NGS_is-at-least-one { obj_id set_attribute set_item_attribute test_condition } {
  return "-{
	     -{ [NGS_is-exactly-one $obj_id $set_attribute $set_item_attribute $test_condition] }
	   }"
}
