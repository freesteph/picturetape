# frozen_string_literal: true

require 'date'

module PictureTape
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

    def read!
      # raw = `identify -format '%[exif:DateTimeOriginal]' #{file}`
      raw = `identify -format '%[date:create]' #{file}`

      @meta = DateTime.parse(raw)
    end
  end
end
