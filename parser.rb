#!/usr/bin/env ruby
require 'bundler'
Bundler.setup

require 'treetop'
require 'pp'
base_path = File.expand_path(File.dirname(__FILE__))
Treetop.load(File.join(base_path,'stats_log.treetop'))

file = File.open('stats.log','r')
contents = file.read

slp = StatsLogParser.new
slp.consume_all_input = false
arr = []
begin
  arr << slp.parse(contents, :index => slp.index || 0).process
end until slp.index == contents.length

pp arr