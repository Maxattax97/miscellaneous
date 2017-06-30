#!/bin/bash

tmux new-session -d -s "respawn-example"
tmux set -g remain-on-exit on
tmux selectp -t 0                      
tmux split-window -v 'htop'
tmux -2 attach-session -d 
