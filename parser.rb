#!/usr/bin/env ruby
require 'bundler'
Bundler.setup

require 'treetop'
require 'pp'
require 'csv'
base_path = File.expand_path(File.dirname(__FILE__))
Treetop.load(File.join(base_path,'stats_log.treetop'))

file = File.open('stats.log','r')
contents = file.read

slp = StatsLogParser.new
slp.consume_all_input = false

CSV.open('stats.csv','w') do |writer|
  begin
    sample = slp.parse(contents, :index => slp.index || 0).process
    if(slp.index == 0)
      sample = slp.parse(contents, :index => 0).process
      header = [:time]
      sample[:values].inject(header) do |arr,cntr|
        arr << cntr[:name]
      end
      writer << header
    end

    row = [sample[:date].to_time.to_i]
    sample[:values].inject(row) do |arr, cntr|
      arr << cntr[:value]
    end
    writer << row
  end until slp.index == contents.length
end

# {:date=>#<DateTime: 2010-01-12T17:29:43+00:00 (212130077383/86400,0/1,2299161)>, :values=>[{:counter=>"decoder.pkts", :module=>"Decode & Stream", :value=>3115376.0},
