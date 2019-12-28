# frozen_string_literal: true

require './lib/chronolog.rb'
require './lib/logger.rb'

module PictureTape
  class Scrapper
    EXTENSIONS = %w[jpg png jpeg tiff bmp].freeze

    attr_reader :options

    def initialize(options)
      @params = options
    end

    def path
      @params[:path]
    end

    def scrappable?
      EXTENSIONS.include?(File.extname(path).downcase.gsub('.', ''))
    end

    def directory?
      Dir.exist? path
    end

    def scrape!
      PictureTape::Logger.log "looking at #{path}..."

      if directory?
        handle_dir
      elsif scrappable?
        handle_file
      else
        PictureTape::Logger.log "skipping as #{File.basename(path)} is not scrappable"
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
        Scrapper.new(@params.merge(path: f)).scrape!
      end
    end

    def link_asset(date)
      dest = File.join(
        @params[:library],
        date.year.to_s,
        date.month.to_s,
        date.day.to_s
      )

      `mkdir -p #{dest}`

      @do_copy ? copy_file(path, dest) : link_file(path, dest)
    end

    def copy_file(src, dest)
      `cp #{src} #{dest}/#{File.basename(path)}`
    end

    def link_file(src, dest)
      `ln -s #{src} #{dest}/#{File.basename(path)}`
    end

  end
end
