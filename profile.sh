#!/bin/bash

set -e
ruby spacestuff.rb --profile
bundle exec pprof.rb --svg spacestuff.profile > spacestuff-profile.svg
open spacestuff-profile.svg
