#!/usr/bin/env bash

# -i file
# Read URLs from a local or external file
# -x
# The opposite of -nd create a hierarchy of directories, even if one would not have been created otherwise.
# E.g. wget -x http://fly.srk.fer.hr/robots.txt will save the downloaded file to fly.srk.fer.hr/robots.txt.
# -nH
# Disable generation of host-prefixed directories.  By default, invoking Wget with -r http://fly.srk.fer.hr/
# will create a structure of directories beginning with fly.srk.fer.hr/.  This option disables such behavior.
# -P prefix
# Set directory prefix to prefix.  The directory prefix is the directory where all other files and subdirectories
# will be saved to, i.e. the top of the retrieval tree.  The default is . (the current directory).
wget -P downloads -nH -x -i "$1"
