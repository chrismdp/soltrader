require "rubygems"
require "bundler/setup"

require 'chingu'
include Gosu

require_relative "lib/spacestuff"

Game.new.show
