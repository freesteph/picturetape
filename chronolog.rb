# frozen_string_literal: true

require 'date'
require './logger.rb'

module PictureTape
  # this class tries and identify the date/time a picture was taken
  # based on a very simple heuristic at the moment:
  # 1. embedded EXIF date
  # 2. file creation date which is usually wrong but
  # 3. there is no 3. yet
  class Chronolog
    attr_reader :file

    def initialize(file)
      @file = file
    end

    def meta
      @meta || read!
    end

    def to_s
      meta
    end

    private

    def format_exif_date(raw)
      date, time = raw.split

      date.gsub!(':', '-')

      "#{date} #{time}"
    end

    def read!
      raw = `identify -format '%[exif:DateTimeOriginal]' #{file}`

      if $?.success? and !raw.empty?
        date = format_exif_date raw
      else
        PictureTape::Logger.log('EXIF data is not present, reverting to creation date')

        date = `identify -format '%[date:create]' #{file}`
      end

      @meta = DateTime.parse(date)
    end
  end
end
