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
will take hours to track down and fix when it emerges.

What do you need to write tests? Just the `z80unit.asm` file. It is
self-contained and is all you need. Well, also you have to write the test code.
Let's look into how to do that.

## Quick Start

The below shows a simple test

```
  org $7000
import 'z80unit.asm'

s1      defb    'a test'
s2      defb    'a test'

main:
  z80unit_test 'reg adds'
  ld a,5
  add 5
  assertEquals8 10,a
  ld hl,900
  inc hl
  assertEquals16 hl,901

  z80unit_test 'memory blocks'
  assertMemString s1,'a test'
  assertMemString s1+2,'test'
  assertMemEquals8 s1,s2,3,'3 chars only'
  assertMemEquals8 s1,s2,6

  z80unit_end_and_exit
  end main
```

You don't have to type this in it is in
[quick_start_test.asm](https://github.com/hallorant/bigmit/blob/master/z80unit/examples/quick_start_test.asm).
In the
[examples](https://github.com/hallorant/bigmit/tree/master/z80unit/examples)
subdirectory. To compile this test use:

```zmac --zmac quick_start_test.asm```

To run in the emulator use

```trs80gp zout/quick_start_test.500.cas```

You can also load the test onto a real Model 1, Model 3, or Model 4 via the
cassette interface. By default z80unit doesn't build in DOS support. We'll
discuss how to test DOS code and code on a Big Tandy below.

You should see the below on the screen

![Running our first z80unit test](..//images/z80unit_qs1.png?raw=true "Running our first z80unit test")

The output reports on your two tests `reg ads` and `memory blocks` and outputs
a `P` for each assertion in the test that passed. If you look back at the code
there were two assertions in `reg ads` and four in `memory blocks` which is
consistent with the output. At the bottom it reports `ALL TESTS PASSED` with
counts of the assertions that passed and failed.  Because we are not using a
DOS we have to reboot the computer when we are done looking at the test output.

### Understanding the test code

Let's examine the test code in more depth.

```
  org $7000
import 'z80unit.asm'

s1      defb    'a test'
s2      defb    'a test'

main:
  z80unit_test 'reg adds'
  ld a,5
  add 5
  assertEquals8 10,a
  ld hl,900
  inc hl
  assertEquals16 hl,901

  z80unit_test 'memory blocks'
  assertMemString s1,'a test'
  assertMemString s1+2,'test'
  assertMemEquals8 s1,s2,3,'3 chars only'
  assertMemEquals8 s1,s2,6

  z80unit_end_and_exit
  end main
```

First off, this test is *really* odd. Why? Normally there would be two `imports`
one for your module and the second for `z80unit.asm`. We just have the import
of `z80unit.asm` in this test. For this simple example, our goal is to
understand z80unit better so we avoid the complexity of the module.

At the top of `main:` we use `z80unit_test` to start and name a test. Each test
contains your code and one or more asserts. You may have as many as you wish.
Finally, at the bottom you end your test with `z80unit_end_and_exit` to print a
report and exit.

### Making the test fail

This example is okay, however, where z80unit shines is when assertions *fail*
and how it reports diagnostic information to help you track down the problem.
Realize that code in the module under test could be broken or the test could be
broken.  You will encounter both problems.

Let's make
[quick_start_test.asm](https://github.com/hallorant/bigmit/blob/master/z80unit/examples/quick_start_test.asm)
fail. Change the first assertion from `assertEquals8 10,a` to

```assertEquals8 $45,a```

Reassemble and run the test as we did before to see

![Our first assertion failure](..//images/z80unit_qs2.png?raw=true "Our first assertion failure")

The test stops when an assertion fails, shows diagnostic information, then prompts you
to press *ENTER* to continue the test.

What does the diagnostic message tell you? We explain each part below.

![The assertion failure diagnostic message explained](..//images/z80unit_qs3.png?raw=true "The assertion failure diagnostic message explained")

In order left to right:

* Instead of the `P` we get an `F` to indicate an assertion failure.

* The code you typed for the assertion. This can help you locate the failing
  assertion within your test code. (The line number would be better, but zmac
  doesn't support that right now.) In most assertions the expected value comes
  first (e.g., `45` hex) followed by the actual value (e.g., the `a` register).

* The `8` in `assertEquals8` refers to the bit size of the data compared.
  z80unit also has `assertEquals16` (and similar) for 16-bit assertions.

* Past the `:` we see what the test observed at the time of the assertion. In
  this example both the expected and actual value are printed. Hex, decimal,
  and ASCII is printed for both. The ASCII value is omitted if it is not printable.
  We see this occur in our example: `0x0A=10` doesn't show an ASCII value because
  10 is not printable.

* Below the diagnostic message we see `Press <ENTER> when ready to continue...`
  This prompt stops the test and lets you read the diagnostic message. It would
  be sad to have a great diagnostic message scroll off the TRS-80 screen before
  you can read it.

At this point press *ENTER* and you will see

![At the end of running the test](..//images/z80unit_qs4.png?raw=true "At the end of running the test")

Note that the library removes the `Press <ENTER> when ready to continue...`
from the output so the TRS-80 screen isn't cluttered up with these messages.

### Adding your own diagnostic message

You may optionally add to the diagnostic message to any assertion. An example
of this is the `'3 chars only'` in the line

```assertMemEquals8 s1,s2,3,'3 chars only'```

To see this assertion fail change `s2 defb 'a test'` (up top) to

```s2 defb 'A test'"```

Reassemble and run the test as we did before to see

![Adding to the diagnostic message](..//images/z80unit_qs5.png?raw=true "Adding to the diagnostic message")

The output above assumes you pressed *ENTER* on the first assertion failure we
discussed above. As you can see our diagnostic message is included in the output.

This change also breaks the `assertMemEquals8 s1,s2,6` assertion which compares
all six characters in the strings, not just the first three. So you'll have to
press *ENTER* twice to finish the test.

### Running tests on a Big Tandy: DOS support

To run on a Model II or the other machines using a DOS you need to tell z80unit
which DOS you are using. A list of what is supported is below. However, To run
under LDOS 6 we would add the line `z80unit_LDOS6 equ 1` *before* the import of
`z80unit.asm`.

```
  org $7000

z80unit_LDOS6 equ 1
import '../z80unit.asm'

s1      defb    'a test'
s2      defb    'A test'
...
```

That's all you have to do! Assemble the same as before

```zmac --zmac quick_start_test.asm```

But to run in the emulator we need to use the *CMD* output (not *CAS*) and be
clear about the machine and the DOS we want loaded.

```trs80gp -m2 -ld zout/quick_start_test.cmd```

You should see the below on the screen

![Testing on Model II LDOS](..//images/z80unit_qs6.png?raw=true "Testing on Model II LDOS")

The screen above assumes that you pressed *ENTER* when prompted. By this point
you know why the assertions are failing. What differs in this output is what
occurs when the test finishes. Control is returned to the DOS and, in this
example, we see the `LS-DOS Ready` prompt. You do not have to reboot. Go ahead,
type `DATE` or `DIR`, and double-check that the DOS is really still there.

This works on a real Model II, but getting `quick_start_test.cmd` onto the
Model II is a bit involved and we assume you have some approach or another to
do so if you have one of these old machines running.  `quick_start_test.cmd` is
just like any other program.

Why do we need this? The main reason is z80unit wants to *support unit testing
of assembly programs written for a DOS*. With z80unit you can test your LDOS
code that saves high scores to a file in your game. Further, without this
capability the Big Tandy machines would really not be supported by z80unit.

You might have noticed we haven't gone into too much detail about the
assertions themselves. The next section lists *all* the z80unit assertions and
describes how to use them.

# Assertion Reference

## 8-bit assertions

8-bit assertions, where `e`, an expected value, and `a`, an actual value, are
any *exp* valid in `ld a,exp`.  All magnitude comparisons are unsigned.
Optionally, a diagnostic message may be added to any of the below, e.g.,
`assertZero8 0,'my msg'`. (Reminder `e` means *expected* and `a` means *actual*
below -- not register names.)

| Syntax                            | Assertion | Example (given `mysym defb 55`)   |
| --------------------------------- |:---------:| ---------------------------------- |
| `assertZero8` a                   | a == 0    | `assertZero8 ($3c00)`              |
| `assertEquals8` e, a              | e == a    | `assertEquals8 b,a`                |
| `assertNotEquals8` e, a           | e != a    | `assertNotEquals8 (mysym),c`       |
| `assertGreaterThan8` e, a         | e > a     | `assertGreaterThan8 a,'A'`         |
| `assertGreaterThanOrEquals8` e, a | e >= a    | `assertGreaterThanOrEquals8 c,$10` |
| `assertLessThan8` e, a            | e < a     | `assertLessThan8 ($650c),(ix)`  |
| `assertLessThanOrEquals8` e, a    | e <= a    | `assertLessThanOrEquals8 8,9`      |

## 16-bit assertions

16-bit assertions, where `e`, an expected value, and `a`, an actual value, are
either a 16-bit register or any *exp* valid in `ld hl,exp`.  All magnitude
comparisons are unsigned.  Optionally, a diagnostic message may be added to any
of the below, e.g., `assertZero8 0,'my msg'`. (Reminder `e` means *expected*
and `a` means *actual* below -- not register names.)

| Syntax                            | Assertion | Example (given `mysym defw 800`)   |
| --------------------------------- |:---------:| ---------------------------------- |
| `assertZero16` a                  | a == 0    | `assertZero16 hl`                  |
| `assertEquals16` e, a             | e == a    | `assertEquals16 bc,(mysym)`        |
| `assertNotEquals16` e, a          | e != a    | `assertNotEquals16 $3c00,ix`       |

A notable limitation of the 16-bit assertions is that an indirect register
value, such as `(hl)` or `(ix)`, is not supported because the z80 only supports
this for 8-bit loads and stores. Of course, you can use `hl` or `ix`, but not
as pointers to memory to load a 16-bit value. We have left the magnitude
comparisons as future work so please let us know if that limitation is limiting
for your testing.

## Memory block assertions

Memory block assertions check memory against an expected vector of bytes.
Pointer values are either a 16-bit register or any *exp* valid in `ld hl,exp`.
The 8 and 16 in `assertMemEquals8` and `assertMemEquals16` refer to the count,
`cnt`, of bytes to check.

| Syntax                           | Assertion                                                    | Example (given `s1 defb 'ah'` and `s2 defb 'ha'` and `double_buffer equ $8c00`) |
| -------------------------------- | ------------------------------------------------------------ | ------------------------------------------------------------------------------- |
|  `assertMemString` ptr, string   | memory at *ptr* contains *string*                            | `assertMemString hl,'Weerd'`                                                    |
|  `assertMemEquals8` p1, p2, cnt  | memory at *p1* and *p2* equal for *cnt* (8-bit value) bytes  | `assertMemEquals8 s1,s2,2`                                                      |
|  `assertMemEquals16` p1, p2, cnt | memory at *p1* and *p2* equal for *cnt* (16-bit value) bytes | `assertMemEquals16 $3c00,(double_buffer),1024`                                  |

# DOS Reference
 
z80unit allows testing in many TRS-80 DOS environments. If you are developing a
program for a DOS then its tests should run in that DOS. To do this add a line
at the top of your test, prior to the import of z80unit.asm, defining **one and
only one** of the OS values listed in the table below. For example

```
  org $7000

z80unit_m2_TRSDOS equ 1
import '../z80unit.asm'
...
```

| Symbol                 | Description                               | Reference Document                                               | Tested On                           |
| ---------------------- | ----------------------------------------- | ---------------------------------------------------------------- | ----------------------------------- |
| `z80unit_LDOS5`        | Model 1 or Model 3 LDOS 5.1 (or similar)  | *LDOS Version 5.1: The TRS-80 Operating System Model I and III*  | TRSDOS 3.3, LDOS 5.3.1              |
| `z80unit_m2_TRSDOS`    | Model II TRSDOS version 2.0a (or similar) | *TRS-80 Model II Disk Operating System Reference Manual*         | TRSDOS 2.0a                         |
| `z80unit_m3_TRSDOS1.3` | Model III TRSDOS version 1.3 (or similar) | *TRS-80 MODEL III Operation and BASIC Language Reference Manual* | Model III TRSDOS 1.3, NewDos/80 2.0 |
| `z80unit_LDOS6`        | Model II / Model 4 LDOS 6 (or similar).   | *The Programmer's Guide to TRSDOS Version 6*                     | TRSDOS 06.02.01, LDOS 06.03.01      |

A few bits of advice

* You must use one of these on a Big Tandy (Model II, Model 12, Model 16, or
  Model 6000). Probably `z80unit_m2_TRSDOS` or `z80unit_LDOS6`. Why? the
  default z80unit approach to write directly to video memory doesn't work on
  these machines. (Nothing is easy on a Big Tandy!)

* If your target DOS is not on this list, try a few values. Guess what might
  work and use `trs80gp` to see if it works. Please reach out if you have
  success or report your need for a particular DOS.

# Limitations

We know about a few limtations, please let us know if you run into any new
ones.

* Running on a real Model 1 with no lowercase modification doesn't work.
  For the curious, you can see the mess by running your test with
  `trs80gp -m1 -nlc mytest.500.cas` it sorta runs but all the nice text
  is unreadable. A workaround is to change all the strings in
  `z80unit.asm` to uppercase. Another option is to contact
  [Ian Mavric](http://members.iinet.net.au/~ianmav/trs80/) and get a
  lowercase modification into your machine!

* The implementation of z80unit is macros on top of macros, so the error
  messages out of zmac can be a bit cryptic. Keep your tests small and
  run them as you add new assertions.

* No line numbers for assertion failures. We have to enhance zmac to get
  this feature.

* Tests have to use `zmac --zmac ...` because we use a lot of advanced features
  George Phillips added to zmac. Please realize you do not have to do this for
  your program. Just your unit tests.
