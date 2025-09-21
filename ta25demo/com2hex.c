#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define RECORD_SIZE 16

// Function to calculate and format the Intel HEX checksum
void format_checksum(unsigned char *buffer, int len, FILE *outFile) {
    int i;
    unsigned char sum = 0;
    for (i = 0; i < len; i++) {
        sum += buffer[i];
    }
    // Calculate the two's complement of the sum
    unsigned char checksum = (unsigned char)(0x100 - sum);
    fprintf(outFile, "%02X\r\n", checksum);
}

// Main conversion function
void com_to_hex(const char *com_filename, const char *hex_filename) {
    FILE *inFile, *outFile;
    unsigned char buffer[RECORD_SIZE];
    int bytes_read;
    int address = 0x100; // CP/M .com files start at 0100h

    // Open input .com file for binary read
    inFile = fopen(com_filename, "rb");
    if (inFile == NULL) {
        fprintf(stderr, "Error: Could not open input file %s\n", com_filename);
        return;
    }

    // Open output .hex file for write
    outFile = fopen(hex_filename, "w");
    if (outFile == NULL) {
        fprintf(stderr, "Error: Could not open output file %s\n", hex_filename);
        fclose(inFile);
        return;
    }

    // Read the .com file in chunks and write Intel HEX records
    while ((bytes_read = fread(buffer, 1, RECORD_SIZE, inFile)) > 0) {
        unsigned char record_start[4];
        record_start[0] = bytes_read;
        record_start[1] = (address >> 8) & 0xFF;
        record_start[2] = address & 0xFF;
        record_start[3] = 0x00; // Record type 00 (data)

        // Write the record header
        fprintf(outFile, ":%02X%04X%02X", record_start[0], address, record_start[3]);

        // Write the data bytes
        for (int i = 0; i < bytes_read; i++) {
            fprintf(outFile, "%02X", buffer[i]);
        }
        
        // Calculate and write the checksum
        unsigned char checksum_buffer[4 + RECORD_SIZE];
        memcpy(checksum_buffer, record_start, 4);
        memcpy(checksum_buffer + 4, buffer, bytes_read);
        format_checksum(checksum_buffer, 4 + bytes_read, outFile);

        address += bytes_read;
    }

    // Write the End of File record
    // :00000001FF (byte_count=00, address=0000, type=01, checksum=FF)
    //int eof_char = 26; // ASCII for ^Z
    //fprintf(outFile, ":00000001FF\r\n%c",eof_char);
    fprintf(outFile, ":00000001FF\r\n");

    // Clean up
    fclose(inFile);
    fclose(outFile);
    printf("Successfully converted %s to %s\n", com_filename, hex_filename);
}

// Main function to handle command-line arguments
int main(int argc, char *argv[]) {
    if (argc != 3) {
        fprintf(stderr, "Usage: %s <input.com> <output.hex>\n", argv[0]);
        return 1;
    }
    
    com_to_hex(argv[1], argv[2]);
    return 0;
}

