#!/usr/bin/env sh
cat tmp/pids/unicorn.pid | xargs kill -QUIT
bundle exec unicorn -E production -c unicorn.rb -D

