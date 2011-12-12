#!/bin/bash

set -e
ruby sol.rb --profile
bundle exec pprof.rb --svg sol.profile > sol-profile.svg
open sol-profile.svg
