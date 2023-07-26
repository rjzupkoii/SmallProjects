#!/usr/bin/env python3

# iso3166.py
#
# This script downloads the JavaScript files from the wooorm/iso-3166 repository
# on GitHub and parses them into CSV files that can be used by other applications.
import argparse
import os
import re
import urllib.request

# The core data comes from https://github.com/wooorm/iso-3166
ISO_6166_URL = 'https://raw.githubusercontent.com/wooorm/iso-3166/main/{}.js'

# Filename template to use
ISO_6166_TEMPLATE = 'iso_3166-{}.csv'


def get_iso(path, level):
    working = []

    # Download the data
    print('Downloading ISO 3166-{} codes...'.format(level), end='', flush=True)
    temp = urllib.request.urlretrieve(ISO_6166_URL.format(level))
    print('done!')
    print(temp[1])

    # Read the file and strip the header information
    print('Parsing ISO 3166-{} codes...'.format(level), end='', flush=True)
    with open(temp[0], 'r') as file:
        data = file.read()
    data = data[data.find('export const iso3166{}'.format(level)):]

    # Parse the subregion codes out of the file
    while data.find('}') != -1:
        # Find the subregion
        lbrace = data.find('{')
        rbrace = data.find('}')
        region = data[lbrace + 1:rbrace]

        # Update our list
        matched = re.findall(r"['\"](.*)[\"']", region)
        if matched != None and level == 1:
            working.append('{},{},{},"{}"\n'.format(int(matched[4]),matched[2],matched[3], matched[0]))
        elif matched != None and level == 2:
            working.append('{},{},"{}"\n'.format(matched[2], matched[0], matched[1]))

        # Move to the next group
        data = data[rbrace + 1:]

    # Save the data to disk
    filename = os.path.join(path, ISO_6166_TEMPLATE.format(level))
    with open(filename, 'w') as file:
        if level == 1:
            file.write('numeric,alpha2,alpha3,name\n')
        elif level == 2:
            file.write('parent,code,name\n')
        for line in working:
            file.write(line)
    print('done!\nSaved as: {}'.format(filename))


def main(args):
    # Create the path if it does not exist
    if not os.path.isdir(args.path):
        os.makedirs(args.path)

    # Load both if the level is not provided
    if args.level is None:
        get_iso(args.path, 1)
        get_iso(args.path, 2)
    
    # Otherwise, make sure we have a valid level
    elif not args.level.isdigit():
        print('Level must be provided as a single digit (i.e., 1 for country codes or 2 for subregional codes)')
        return

    # We must have a number, try to work with it
    else:
        level = int(args.level)
        if level in [1, 2]:
            get_iso(args.path, level)
        else:
            print('Unknown level ({}), expected 1 for country codes or 2 for subregional codes'.format(level))


if __name__ == '__main__':
    # Parse the arguments and invoke the main function
    parser = argparse.ArgumentParser()
    parser.add_argument('-p', action='store', dest='path', required=True,
        help='The path to save the file(s) under, will be created if it does not exist.')
    parser.add_argument('-l', action='store', dest='level', required=False,
        help='The ISO 3166 level to download, 1 for country codes, 2 for subregional codes. It not supplied both are downloaded.')
    main(parser.parse_args())
