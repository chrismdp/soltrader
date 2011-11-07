require "rubygems"
require "bundler/setup"

require 'chingu'
require 'texplay'
require 'chipmunk'

include Gosu

require_relative "lib/spacestuff"

Spacestuff::Window.new.show
