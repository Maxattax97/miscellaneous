#!/bin/bash

exec xautolock -detectsleep \
  -time 5 -locker "light-locker-command -l" \
