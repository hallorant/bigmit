package trs80;

import java.io.*;
import java.util.*;

public class GenerateDictionaryBitSteam {

    static LetterFrequency frequency = new LetterFrequency();

    public static void main(String[] args) throws UnsupportedEncodingException, FileNotFoundException {
        Dictionary dictAnswer = new Dictionary();
        dictAnswer.addFile("answer.txt");

        BitCollector sinkAnswer = new BitCollector();
        for (String word : dictAnswer.words) {
            sinkAnswer.appendLetters(word);
        }

        Dictionary dictRest = new Dictionary();
        dictRest.addFile("rest.txt");

        SuffixGenerator suffixGenerator = new SuffixGenerator();
        for (String word : dictRest.words) {
            suffixGenerator.addWord(word);
        }
        System.out.println((suffixGenerator));

        BitCollector sinkRest = new BitCollector();
        int atLetter = 0;
        for (SuffixNode node : suffixGenerator.traversal) {
            if (atLetter == 0) {
                // At first letter, skip first letter output as it can be inferred.
                sinkRest.appendLetters(node.suffix.substring(1));
            } else {
                sinkRest.appendLetters(node.suffix);
            }

            sinkRest.appendInt3Bits(node.upSuffix);

            atLetter = 5 - node.upSuffix; // we always output a whole word, then go up
        }

        // Output zmac assembly code to dictionary_data.asm file.
        PrintWriter out = new PrintWriter("dictionary_data.asm");
        out.println("ifndef INCLUDE_DICTIONARY_DATA");
        out.println("INCLUDE_DICTIONARY_DATA equ 1");
        out.println();
        out.println("dictionary_data:");
        out.println();
        out.println("; ----------------");
        out.println("; -- answer.txt --");
        out.println("; ----------------");
        out.println("; Bit encoding of answer.txt w/file order unchanged.");
        out.println("; o 5 letters (Huffman).");
        out.println("; o To determine answer number, count up while reading.");
        out.println("; o To determine end, stop after " + dictAnswer.words.size() + " words.");
        out.println("answer_data:");
        out.println(sinkAnswer);
        out.println("answer_data_size equ $-answer_data");
        out.println();
        out.println("; ---------------");
        out.println("; -- rest.txt --");
        out.println("; ---------------");
        out.println("; Bit encoding of rest.txt focused on suffix of each word:");
        out.println("; o Note that the rest.txt file is sorted.");
        out.println("; o The first letter of each word is not included. It ranges through the alphabet.");
        out.println("; o 1 to 4 letters (Huffman), followed by 3 bit up-value.");
        out.println("; o 3 bit up-value of 1-5 indicating length in characters of the next suffix.");
        out.println("; o 3 bit up-value of 0 indicates end of rest.txt words.");
        out.println("rest_data:");
        out.println(sinkRest);
        out.println("rest_data_size equ $-rest_data");
        out.println();
        out.println("dictionary_data_size equ $-dictionary_data");
        out.println();
        out.println("endif ; INCLUDE_DICTIONARY_DATA");
        out.close();

        System.out.println(frequency.stats);
    }

    /**
     * A single node for our Suffix class that holds information about the depth-first traversal.
     */
    static class SuffixNode {
        String word; // Five-letter word (for diff)
        String suffix;  // One to Five letters
        int upSuffix = 0; // How many letters to go up from the end of the word, last must be zero

        @Override
        public String toString() {
            return "SuffixNode{" + "word='" + word + '\'' + ", suffix='" + suffix + '\'' + ", upSuffix=" + upSuffix + "}\n";
        }
    }

    /**
     * A suffix representation specialized to our particular Wordle problem.
     */
    static class SuffixGenerator {
        final List<SuffixNode> traversal = new ArrayList<>();

        void addWord(String word) {
            if (word.length() != 5) throw new RuntimeException("Words must be 5 characters..." + word);
            SuffixNode node = new SuffixNode();
            node.word = word;
            if (traversal.isEmpty()) {
                node.suffix = word;
            } else {
                SuffixNode last = traversal.get(traversal.size() - 1);
                last.upSuffix = diffUpSuffix(last.word, node.word);
                node.suffix = word.substring(5 - last.upSuffix);
            }
            traversal.add(node);
        }

        int diffUpSuffix(String prev, String curr) {
            if (prev.charAt(0) != curr.charAt(0)) return 5;
            if (prev.charAt(1) != curr.charAt(1)) return 4;
            if (prev.charAt(2) != curr.charAt(2)) return 3;
            if (prev.charAt(3) != curr.charAt(3)) return 2;
            return 1;
        }

        @Override
        public String toString() {
            StringBuilder b = new StringBuilder();
            int pad = 0;
            for (SuffixNode node : traversal) {
                b.append(".".repeat(pad)).append(node.suffix).append(" <").append(node.word).append("> (");
                if (node.upSuffix == 0) {
                    b.append("END)");
                } else {
                    b.append("^").append(node.upSuffix).append(")\n");
                }
                pad = 5 - node.upSuffix;
            }
            return b.toString();
        }
    }

    /**
     * Raw dictionary of words which includes answer.txt and rest.txt words.
     */
    static class Dictionary {
        final List<String> words = new ArrayList<>();

        void addFile(String filename) {
            try {
                int indexInFile = 0;
                BufferedReader bufReader = new BufferedReader(new FileReader(filename));
                String line = bufReader.readLine();
                while (line != null) {
                    // Ensure the word is 5 characters.
                    if (line.length() != 5)
                        throw new RuntimeException("Words must be 5 characters..." + line + " in file " + filename);
                    words.add(line);
                    line = bufReader.readLine();
                    indexInFile++;
                }
                bufReader.close();
            } catch (IOException e) {
                throw new RuntimeException("Failure adding " + filename, e);
            }
        }
    }

    static class BitCollector {
        final BitSet bits = new BitSet();
        int inUse = 0;

        void appendLetters(String s) {
            for (int i = 0; i < s.length(); i++) {
                frequency.addLetters(String.valueOf(s.charAt(i)));
                appendHuffmanLetter(s.charAt(i));
            }
        }

        void appendHuffmanLetter(Character c) {
            switch (c) {
                case 's':
                    enc("110");
                    break;
                case 'e':
                    enc("011");
                    break;
                case 'a':
                    enc("1011");
                    break;
                case 'r':
                    enc("1001");
                    break;
                case 't':
                    enc("1000");
                    break;
                case 'i':
                    enc("0100");
                    break;
                case 'o':
                    enc("0011");
                    break;
                case 'l':
                    enc("0001");
                    break;
                case 'y':
                    enc("11111");
                    break;
                case 'n':
                    enc("11110");
                    break;
                case 'd':
                    enc("11101");
                    break;
                case 'u':
                    enc("10100");
                    break;
                case 'c':
                    enc("01011");
                    break;
                case 'h':
                    enc("01010");
                    break;
                case 'm':
                    enc("00101");
                    break;
                case 'p':
                    enc("00100");
                    break;
                case 'k':
                    enc("00001");
                    break;
                case 'g':
                    enc("00000");
                    break;
                case 'b':
                    enc("111000");
                    break;
                case 'f':
                    enc("101010");
                    break;
                case 'w':
                    enc("1110011");
                    break;
                case 'v':
                    enc("1110010");
                    break;
                case 'z':
                    enc("1010110");
                    break;
                case 'x':
                    enc("10101111");
                    break;
                case 'j':
                    enc("101011101");
                    break;
                case 'q':
                    enc("101011100");
                    break;
                default:
                    throw new RuntimeException(c + " is an unknown enc() value");
            }
        }

        void enc(String bitstring) {
            for (int i = 0; i < bitstring.length(); i++) {
                if (bitstring.charAt(i) == '1') bits.set(inUse++);
                else bits.clear(inUse++);
            }
        }

        void appendInt3Bits(int value) {
            if ((value >>> 2 & 1) != 0) bits.set(inUse++);
            else bits.clear(inUse++);
            if ((value >>> 1 & 1) != 0) bits.set(inUse++);
            else bits.clear(inUse++);
            if ((value >>> 0 & 1) != 0) bits.set(inUse++);
            else bits.clear(inUse++);
        }

        /**
         * A complex output that encodes the bit stream into zmac assembly code.
         *
         * @return zmac assembly code
         */
        @Override
        public String toString() {
            boolean newLine = true;
            boolean addComma = false;
            int bitCount = 0;
            int byteCount = 0;
            StringBuilder b = new StringBuilder();
            for (int i = 0; i < inUse; i++) {
                if (newLine) {
                    newLine = false;
                    addComma = false;
                    b.append("  byte ");
                }
                if (addComma) {
                    addComma = false;
                    b.append(",");
                }
                b.append(bits.get(i) ? "1" : "0");
                bitCount++;
                if (bitCount == 8) {
                    bitCount = 0;
                    addComma = true;
                    byteCount++;
                    b.append("b");
                }
                if (byteCount > 5) {
                    byteCount = 0;
                    newLine = true;
                    b.append("\n");
                }
            }
            if (bitCount != 0) {
                b.append("0".repeat(8 - bitCount)).append("b");
            }
            return b.toString();
        }
    }

    static class LetterFrequency {
        Map</*letter=*/Character, /*count=*/Integer> stats = new TreeMap<>();

        void addLetters(String value) {
            for (int i = 0; i < value.length(); i++) {
                Character c = value.charAt(i);
                Integer count = stats.get(c);
                stats.put(c, count == null ? 1 : count.intValue() + 1);
            }
        }
    }
}
