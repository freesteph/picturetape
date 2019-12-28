module PictureTape
  class CLI
    attr_reader :parser, :params, :folder

    def initialize(folder)
      @folder = folder
      @params = {}

      @parser = OptionParser.new do |opts|
        opts.banner = 'Usage: ./picturetape.rb FOLDER'

        opts.on(
          '-l=LIBRARY',
          '--library=LIBRARY',
          'Path to the library where the pictures are copied (default: ENV["PICTURETAPE_LIB"]'
        )

        opts.on(
          '-c',
          '--copy',
          'Copy photos to the target folder instead of creating symlinks'
        )
      end
    end

    def run!
      parser.parse!(into: @params)

      coerce_params && check_params

      params
    end

    private

    def coerce_params
      @params[:library] ||= ENV['PICTURETAPE_LIB']
      @params[:path] = @folder
    end

    def check_params
      help_notice = "\nSee ./picturetape.rb --help for program instructions."
      errors = []

      errors << 'Missing FOLDER to process' if @params[:path].nil?
      errors << 'No library provided' if @params[:library].nil?

      return if errors.empty?

      puts ['Some errors in your invocation: ',
            make_list(errors),
            help_notice].join("\n\n")

      exit
    end

    def make_list arr
      arr.map { |e| "* #{e}"}.join(";\n")
    end
  end
end
