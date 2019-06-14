#!/bin/bash

exec xautolock -detectsleep \
  -time 10 -locker "light-locker-command -l" \
