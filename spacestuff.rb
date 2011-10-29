require "rubygems"
require "bundler/setup"

require 'chingu'
include Gosu

require_relative "lib/spacestuff"

Spacestuff::Game.new.show
