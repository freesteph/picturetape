# frozen_string_literal: true

require './lib/scrapper.rb'

module PictureTape
  class Library
    attr_reader :path
    attr_reader :scrapper

    def initialize(path)
      @path = path
      @scrapper = PictureTape::Scrapper.new(path)
    end

    def scrape!(folder)
      @scrapper.process!(folder)
    end
  end
end
