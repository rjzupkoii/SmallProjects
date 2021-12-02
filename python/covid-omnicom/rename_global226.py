#!/usr/bin/python3

# rename.py
# 
# This file applies the correct naming convention to the AFA file and 
# generates the dictionary of labels to be used for the phylogenetic 
# tree.
import glob

# Files and paths we are concerned with
ALIGNED = 'global_subsample_and_omicrons_226.afa'
TREES = '3.2.3 whole-genome tree/*.global226'

labels = {}

# Start by processing the aligned FASTA file
with open(ALIGNED, 'r') as fasta:
    for line in fasta:
        if not line.startswith('>'): continue

        # Clip the carrot, split, and strip
        line = line[1:].split('|')
        line = list(map(str.strip, line))

        # Pass when there are only three entries
        if len(line) == 3: continue

        # Create the new label
        key = line[0]
        label = "{}/{}/{}".format(line[2], line[0], line[3]).replace(' ', '_')
        if key not in labels:
            labels[key] = label

# Next update the tree files
for file in glob.glob(TREES):
    # Read the entire tree
    data = ''
    with open(file, 'r') as input:
        data = input.read()
    
    # Update the tree
    for key in labels:
        data = data.replace(key, labels[key])

    # Write the updated tree
    with open(file + '.updated2', 'w') as output:
        output.write(data)