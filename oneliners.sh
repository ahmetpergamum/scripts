#!/bin/bash

# To change "spaces" to "_" in all .pdf file names in directory
for i in *.pdf ; do mv $i $(ls $i | sed 's/ /_/g') ; done
