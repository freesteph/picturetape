# frozen_string_literal: true

require 'logger'

module PictureTape
  # a slightly more precise logging class
  class Logger
    def self.instance
      @logger ||= ::Logger.new(STDOUT, progname: 'PictureTape')
    end

    def self.log(msg)
      instance.info msg
    end
  end
end
