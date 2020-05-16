# z80unit - Programmer-friendly unit testing for TRS-80 assembly

Supports unit testing on all z80 TRS-80s and most DOSs.

## Introduction

As your TRS-80 programs get larger it becomes difficult to change them without
risk. Unit testing can not only help you get your code to be correct but can
help you keep it correct as it evolves. We wrote this unit testing framework to
help develop larger TRS-80 assembly language programs. It is designed to have
the feel of [JUnit for Java](https://junit.org) for Java or [Google Test for
C++](https://github.com/google/googletest).

## Prerequisites

We require, for tests, that you use zmac from http://48k.ca/zmac.html This code
uses many features of that assembler, we require `--zmac` at least for your
test code. You can build your final program with anything you wish.

We strongly recommend you use trs80gp from http://48k.ca/trs80gp.html but you
don't have to. This library is intended to be useful with real hardware as well
as emulators.

We also assume you develop your z80 assembly language program in components.
If you write all your code in a single file, `myprog.asm`, unit testing won't
help you. We assume you write several components that then get imported into
the your program. z80unit helps you test these component or modules. What goes
in these modules? Subroutines or macros that perform a focused purpose. For
example, a fill routine or a memory move.

How do you test? Let's consider the following program structure:

* `module1.asm`
* `module2.asm`
* `module3.asm`
* `prog.asm`  // imports `module1.asm`, `module2.asm`, `modul3.asm`

You may prefer other extensions, e.g., `.z`, `.inc`, which is no problem.  You
can unit test each module by writing a test for it.

* `module1.asm`
* `module1_test.asm`  // imports `module1.asm`, `z80unit.asm`
* `module2.asm`
* `module2_test.asm`  // imports `module2.asm`, `z80unit.asm`
* `module3.asm`
* `module3_test.asm`  // imports `module3.asm`, `z80unit.asm`
* `prog.asm`  // imports `module1.asm`, `module2.asm`, `modul3.asm`

Ideally, you want to keep `prog.asm` as small as possible because it cannot be
unit tested.

**Note:** You don't need all this structure for smaller programs. As a rule of
thumb: *Tens* of lines of z80 assembly probably don't need unit testing.
However, once you get to *hundreds* or *thousands* of line you probably need to
split up your code into modules and use unit testing. Unit tests help you keep
modules working as you evolve and enlarge your program. Lowering the risk that
a cool change you thought up late in development doesn't introduce a bug that
will take hours to track down and fix when it emerges in use testing of your
program.

What do you need to write tests? Just the `z80unit.asm` file. It is
self-contained and is all you need. Well, also you have to write the test code.
Let's look into how to do that.

## Quick Start

The below shows a simple test

```
  org $7000
<b>import 'z80unit.asm'</b>

s1      defb    'a test'
s2      defb    'a test'

main:
  <b>z80unit_test 'reg adds'</b>
  ld a,5
  add 5
  <b>assertEquals8 10,a</b>
  ld hl,900
  inc hl
  <b>assertEquals16 hl,901</b>

  <b>z80unit_test 'memory blocks'</b>
  <b>assertMemString s1,'a test'</b>
  <b>assertMemString s1+2,'test'</b>
  <b>assertMemEquals8 s1,s2,3,'3 chars only'</b>
  <b>assertMemEquals8 s1,s2,6</b>

  <b>z80unit_end_and_exit</b>
  end main
```
