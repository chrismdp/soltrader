require "rubygems"
require "bundler/setup"

require 'chingu'
require 'texplay'
require 'chipmunk'

include Gosu

require_relative "lib/spacestuff"

require 'perftools'
if ARGV.first == '--profile'
  puts "Profiling"
  PerfTools::CpuProfiler.start("spacestuff.profile") do
    Spacestuff::Window.new.show
  end
else
  Spacestuff::Window.new.show
end


