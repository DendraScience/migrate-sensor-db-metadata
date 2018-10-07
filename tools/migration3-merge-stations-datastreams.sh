#!/bin/bash
# Migrate datastreams and stations into the same directories
# assumes node script in same directory.
parent_path="../data/migration2.1-rivendell/"
target_path="../data/migration3-incidents/"
node ./migration3-merge-stations-datastreams.js $parent_path $target_path ucnrs
node ./migration3-merge-stations-datastreams.js $parent_path $target_path erczo
