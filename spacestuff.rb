require "rubygems"
require "bundler/setup"

require 'chingu'
require 'texplay'
include Gosu

require_relative "lib/spacestuff"

Spacestuff::Game.new.show
