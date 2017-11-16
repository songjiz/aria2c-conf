#!/usr/bin/env ruby
require 'fileutils'
require 'net/http'
require 'uri'

uri  = URI('https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_all.txt')
list = Net::HTTP.get(uri)
trackers = list.split(/\n/).reject(&:empty?).join(',')
conf = File.read('aria2.conf.example')
conf.gsub!(/(?<=bt-tracker[=]")(.*)(?=")/, trackers)
conf.gsub!('$HOME', Dir.home)
File.open('aria2.conf', 'w') { |f| f.puts conf }

conf_dir = File.join(Dir.home, '.aria2')
FileUtils.mkdir_p(conf_dir)
session_file = File.join(conf_dir, 'aria2.session')
FileUtils.touch(session_file) unless File.exist?(session_file)
