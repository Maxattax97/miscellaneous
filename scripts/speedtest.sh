#!/bin/bash
nvim --startuptime test.txt +qa
echo "" >> test.txt
time nvim +qa >> test.txt
