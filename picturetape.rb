#!/bin/ruby

# frozen_string_literal: true

require 'optparse'

require './lib/scrapper.rb'
require './lib/cli.rb'

params = PictureTape::CLI.new(ARGV.shift).run!

PictureTape::Scrapper.new(params).scrape!
