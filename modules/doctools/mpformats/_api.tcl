# -*- tcl -*-
# rules/manpage.api
#
# (c) 2001 Andreas Kupries <andreas_kupries@sourceforge.net>

# Defines the procedures a manpage rules file has to support for good
# manpages. The procedures here return errors.

proc __ {command} {return "return -code error \"Unimplemented command $command\""}
################################################################

proc manpage_begin {title section version} [__ manpage_begin]

proc moddesc     {desc}             [__ moddesc]
proc titledesc   {desc}             [__ titledesc]
proc manpage_end {}                 [__ manpage_end]
proc require     {pkg {version {}}} [__ require]
proc description {}                 [__ description]
proc section     {name}             [__ section]
proc para        {}                 [__ para]
proc list_begin  {what}             [__ list_begin]
proc list_end    {}                 [__ list_end]
proc lst_item    {{text {}}}        [__ lst_item]
proc call        {cmd args}         [__ call]
proc bullet      {}                 [__ bullet]
proc enum        {}                 [__ enum]
proc see_also    {args}             [__ see_also]
proc keywords    {args}             [__ keywords]
proc example     {code}             [__ example]
proc example_begin {}               [__ example_begin]
proc example_end {}                 [__ example_end]
proc nl          {}                 [__ nl]
proc arg         {text}             [__ arg]
proc cmd         {text}             [__ cmd]
proc opt         {text}             [__ opt]
proc emph        {text}             [__ emph]
proc strong      {text}             [__ strong]

proc comment     {text}             [__ comment]
proc sectref     {text}             [__ sectref]
proc syscmd      {text}             [__ syscmd]
proc method      {text}             [__ method]
proc option      {text}             [__ option]
proc widget      {text}             [__ widget]
proc fun         {text}             [__ fun]
proc type        {text}             [__ type]
proc package     {text}             [__ package]
proc class       {text}             [__ class]
proc var         {text}             [__ var]
proc file        {text}             [__ file]
proc uri         {text}             [__ uri]

################################################################
rename __ {}
