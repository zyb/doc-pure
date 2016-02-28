#! /bin/bash

ps aux | grep TM.exe | grep Tencent | awk '{print $2}' | xargs kill -9
