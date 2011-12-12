require "rubygems"
require "bundler/setup"

require 'chingu'
require 'texplay'
require 'chipmunk'

include Gosu

require_relative "lib/sol"

require 'perftools'
if ARGV.first == '--profile'
  puts "Profiling"
  PerfTools::CpuProfiler.start("sol.profile") do
    Sol::Window.new.show
  end
else
  Sol::Window.new.show
end


