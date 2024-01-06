set srcdir [file dirname [file normalize [file join [pwd] [info script]]]]
set moddir [file dirname $srcdir]

puts "Tooling: $srcdir"
puts "Sources: $moddir"

set fout [open [file join $moddir wcswidth.tcl] w]
puts $fout {###
# This file is automatically generated by the build/build.tcl file
# based on information in the following database:
# http://www.unicode.org/Public/UCD/latest/ucd/EastAsianWidth.txt
#
# (This is the 35th edition, thus version 35 for our package)
#
# Author: Sean Woods <yoda@etoyoc.com>
###
package require Tcl 8.5 9
package provide textutil::wcswidth 35.2
namespace eval ::textutil {}}

set fin [open [file join $srcdir EastAsianWidth.txt] r]
puts $fout "proc ::textutil::wcswidth_type char \{"
set hash #
while {[gets $fin line]>=0} {
  set commentidx [string first $hash $line]
  if {$commentidx==0} continue
  set data [string trim [string range $line 0 [expr $commentidx-1]]]
  set comment [string range $line [expr {$commentidx+1}] end]
  if {[scan $line {%6x..%6x;%1s} start end code]==3} {
  } elseif {[scan $line {%5x..%5x;%1s} start end code]==3} {
  } elseif {[scan $line {%4x..%4x;%1s} start end code]==3} {
  } elseif {[scan $line  {%5x;%1s} start code]==2} {
    set end $start
  } elseif {[scan $line  {%4x;%1s} start code]==2} {
    set end $start
  } else {
    puts "Ignored line: '$line'"
    continue
  }
  if {$code eq "N"} continue
  dict set map %start% $start
  dict set map %end% $end
  dict set map %code% $code
  dict set map %comment% [string trim $comment]
  #puts $fout "  $hash $comment"
  if {$start eq $end} {
    puts $fout [string map $map {  if {$char == %start%} { return %code% }}]
  } else {
    puts $fout [string map $map {  if {$char >= %start% && $char <= %end% } { return %code% }}]
  }
}
puts $fout {  return N}
puts $fout "\}"

seek $fin 0
puts $fout "proc ::textutil::wcswidth_char char \{"
while {[gets $fin line]>=0} {
  set commentidx [string first $hash $line]
  if {$commentidx==0} continue
  set data [string trim [string range $line 0 [expr $commentidx-1]]]
  set comment [string range $line [expr {$commentidx+1}] end]
  if {[scan $line {%6x..%6x;%1s} start end code]==3} {
  } elseif {[scan $line {%5x..%5x;%1s} start end code]==3} {
  } elseif {[scan $line {%4x..%4x;%1s} start end code]==3} {
  } elseif {[scan $line  {%5x;%1s} start code]==2} {
    set end $start
  } elseif {[scan $line  {%4x;%1s} start code]==2} {
    set end $start
  } else {
    puts "Ignored line: '$line'"
    continue
  }
  dict set map %start% $start
  dict set map %end% $end
  dict set map %width% 1

  ###
  # Per the unicode recommendations:
  # http://www.unicode.org/reports/tr11/
  #
  #When processing or displaying data:
  #
  # * Wide characters behave like ideographs in important ways, such as layout. Except for
  #   certain punctuation characters, they are not rotated when appearing in vertical text
  #   runs. In fixed-pitch fonts, they take up one Em of space.
  # * Halfwidth characters behave like ideographs in some ways, however, they are rotated
  #   like narrow characters when appearing in vertical text runs. In fixed-pitch fonts,
  #   they take up 1/2 Em of space.
  # * Narrow characters behave like Western characters, for example, in line breaking.
  #   They are rotated sideways, when appearing in vertical text. In fixed-pitch East
  #   Asian fonts, they take up 1/2 Em of space, but in rendering, a non-East Asian,
  #   proportional font is often substituted.
  # * Ambiguous characters behave like wide or narrow characters depending on the context
  #   (language tag, script identification, associated font, source of data, or explicit
  #   markup; all can provide the context). If the context cannot be established reliably,
  #   they should be treated as narrow characters by default.
  # * [UTS51] emoji presentation sequences behave as though they were East Asian Wide,
  #   regardless of their assigned East_Asian_Width property value. (Not implemented here)
  ###
  switch $code {
    W -
    F {
      dict set map %width% 2
    }
    A -
    N -
    Na -
    H {
      continue
    }
  }
  dict set map %code% $code
  dict set map %comment% [string trim $comment]
  #puts $fout "  # $comment"
  if {$start eq $end} {
    puts $fout [string map $map {  if {$char == %start%} { return %width% }}]
  } else {
    puts $fout [string map $map {  if {$char >= %start% && $char <= %end% } { return %width% }}]
  }
}
puts $fout {  return 1}
puts $fout "\}"
puts $fout {
proc ::textutil::wcswidth {string} {
  set width 0
  set len [string length $string]
  foreach c [split $string {}] {
    scan $c %c char
    set n [::textutil::wcswidth_char $char]
    if {$n < 0} {
      return -1
    }
    incr width $n
  }
  return $width
}
}