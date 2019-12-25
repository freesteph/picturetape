# frozen_string_literal: true

require './chronolog.rb'

module PictureTape
  class Scrapper
    EXTENSIONS = %w[jpg png jpeg tiff bmp].freeze

    attr_reader :lib
    attr_reader :path

    def initialize(lib)
      @lib = lib
    end

    def scrappable?
      EXTENSIONS.include?(File.extname(path).downcase.gsub('.', ''))
    end

    def directory?
      Dir.exist? path
    end

    def process!(path)
      @path = path

      if directory?
        handle_dir
      elsif scrappable?
        handle_file
      else
        puts "skipping as #{File.basename(path)} is not scrappable"
      end
    end

    private

    def handle_file
      date = Chronolog.new(path).meta

      link_asset(date)
    end

    def handle_dir
      files = Dir.glob(File.join(path, '*'))

      files.each do |f|
        Scrapper.new(lib).process!(f)
      end
    end

    def link_asset(date)
      dest = File.join(lib, date.year.to_s, date.month.to_s, date.day.to_s)

      `mkdir -p #{dest}`
      `ln -s #{path} #{dest}/#{File.basename(path)}`
    end
  end
end
