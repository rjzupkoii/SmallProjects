#!/usr/bin/python3 -O

# subsample_fasta.py
#
# Scan the FASTA files that are present in the directory and generate a subsample file
import argparse
import glob
import os
import random

OUTPUT = 'all_file_subsample.fa'

def main(folder, count):
    with open(OUTPUT, 'w') as output:
        for file in glob.glob(os.path.join(folder, "*.fasta")):
            with open(file, 'r') as input:
                # Reset variables
                lines = []

                # Scan the file for the location of the samples
                print("Scanning {} ...".format(file))
                data = input.readline()
                while data:
                    if data.startswith('>'):
                        lines.append(input.tell() - len(data))      # Sample offset
                    data = input.readline()
                lines.append(input.tell())                          # File length

                # Generate our sample set, note the last entry is the EOF
                samples = range(len(lines) - 1)
                if count < len(lines) - 1:
                    samples = random.sample(samples, count)

                # Write the samples to the output
                print("Sampling {} samples of {} ...".format(count, len(lines)))
                for sample in sorted(samples):
                    input.seek(lines[sample])
                    block = input.read(lines[sample + 1] - lines[sample])
                    output.write(block)

    print("Results written to {}".format(OUTPUT))


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('-f', action='store', dest='folder', required=True,
        help='The folder to read the FASTA files from')
    parser.add_argument('-s', action='store', dest='count', required=True,
        help='Number of samples to store')
    args = parser.parse_args()
    main(args.folder, int(args.count))
