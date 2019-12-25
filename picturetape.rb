# frozen_string_literal: true

require 'optparse'

require './library.rb'

options = {}

OptionParser.new do |opts|
  opts.banner = 'Usage: ruby picturetape.rb FOLDER'

  opts.on(
    '-l=LIBRARY',
    '--library=LIBRARY',
    'Library where the pictures are copied to (default: ENV["PICTURETAPE_LIB"]'
  )
end.parse!

library = PictureTape::Library.new(options[:library] || ENV['PICTURETAPE_LIB'])
library.scrape!(ARGV.shift)
