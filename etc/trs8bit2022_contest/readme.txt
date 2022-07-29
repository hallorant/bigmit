Wordle is a word matching game.

The computer picks a 5 letter word.  You have 6 chances to guess that word.
After each guess the computer will judge your guess by marking each letter.
Letters may either be:

	Correct - the letter is the same as the one in the answer.
	Close - the letter is in the word but not in that place.
	Wrong - the letter does not appear anywhere in the word.

If all 5 letters are an exact match the player has guessed the word and they
win.  If the word is not guessed in 6 tries the computer shows the correct
answer.

The judging rules are a little bit subtle when it comes to letters repeated
in the answer or the guess.  To handle it properly, follow this or an
equivalent procedure:

	Mark each of the 5 letter positions in the answer as available.

	Mark the 5 letters positions of the guess as "wrong".

	For each letter in the guess that is an exact match:
		Mark the guess letter position as "correct"
		Mark the answer letter position as not available.

	Working from left to right go through the 5 letter positions.
		If the guess at that position is "correct" continue to the next one.
		If there is a letter in the answer that matches and is available then:
			Mark the guess letter position as "close".
			Mark the answer letter position as not available.

	Now all the guess positions have been marked and can be displayed.

For example, if the answer is LIGHT then the guess SKILL will have the
I and first L marked as close and the rest (including the last L) as wrong.
If TACET is guessed then the final T will be marked as correct and the
rest (including the first T) as wrong.

You may wish to display a letter tracker to help the player.  This shows
the entire alphabet and starts out with every letter in an unused state.
When a letter is guessed correctly it will be marked as correct in the
tracker.  A letter marked as a close will be close in the tracker.
Letters marked as wrong will be marked as wrong in the tracker.  The
tracker will show the best state of the letter.  A correct letter will
show as correct even if it has also been close or a miss.  And a close
letter will be shown even if it was also wrong in a guess.  Otherwise,
a guessed letter will shown as wrong.

You may also implement hard mode.  In hard mode the player must always
use correct letters from previous guesses.  Every correct letter is fixed
in that it must be used in that place in subsequent guesses.  And all
close letters must be used.  Any letter marked as close in the tracker
must be put in some position in subsequent guesses.  However, letters
marked as wrong in the tracker may still be used.  Though it would be
foolish for the player to do so.

How the computer picks the word for a puzzle is up to you.  It will
be from a fixed list of answer words as listed in answer.txt
The wrd80 example program asks the player for a number from 1 to 2313
to pick the answer which lets them advance through the word list
without spoiling anything as the list is (in theory) not known to them.  
You might want to simply pick random words or base the word on the
current date or what have you.

When the player guesses a word it must be a word that appears either in
the answer list or the secondary rest.txt list.  A guess that does not
appear in either list is invalid and the player will be asked for another
word.  Invalid words don't count as one of the 6 guesses.  Unless you
want to make that a super hard mode.

If you're implementing the full game you may limit the list of words in
order to fit the target platform or make the implementation tractable.

If you're on the technical track then you must include all the words.
And they must fit into memory.

The essential challenge of the technical track is to pack the dictionary
and the routine to access it into as small a space as possible.  It must
be written in machine code but can be for most any CPU used in a TRS-80.
Z-80, 6809, 8085, 6803, 68000, 80186.  There are two routines to implement:

	getpuz - get a word from the answer.txt list of words
	isword - test if a word is in either answer.txt or rest.txt

For getpuz the word number is passed in DE, D, d0.l or BX.  You can
depend on it being in a legal range from 0 .. 2312.  The routine must
write the 5 letter word in ASCII into a buffer at HL, X, a0 or DS:DI.
The words must be returned in the same order as in answer.txt  Word 0
must be TANDY, word 1 must be RADIO and so on up to word 2312 being DWARF.

isword takes a pointer to the 5 letter ASCII word in HL, X, a0 or DS:DS.
It returns the result in A, d0.l or AX register.  A zero indicates the
word is not in the dictionary (i.e., neither in answer.txt or rest.txt).
A non-zero value means the word is in the dictionary.

Entries with source code are preferred but raw binary data is acceptable.
Please indicate where the binary loads into memory and the offsets to
the getpuz and isword subroutines.

The code must be self contained and not make any calls to ROM, Operating
System or any other external code.

Size is judged strictly on the size of the binary.  You may use as much
run time memory as you wish.  Hopefully this does not put Model 16 or
2000 programmers at too much of an advantage.

wrd80.z is an example entry that packs the 12960 words of the dictionary
into 3 byte, 5 digit base 26 numbers requiring 38880 bytes of memory.
The actual entry is the dict.inc and wrd.inc files.  The source code
includes a dict_size equate to quickly determine the size -- 39068 bytes.

The rest is a minimal but playable version of the game that runs on
TRS-80 Model 1, 2, 3 and 4 machines.  Feel free to use it as a testbed
for your own routines.
