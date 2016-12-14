module Npm
  module Rails
    class PackageFileParser

      attr_reader :packages
      attr_reader :exports

      def self.parse(package_file_path)
        parser = new
        parser.parse(package_file_path)
        { packages: parser.packages, exports: parser.exports }
      end

      def initialize
        @packages = []
        @exports = []
        @development = false
      end

      def parse(package_file_path)
        @package_file = File.open(package_file_path, "r", &:read)
        eval(@package_file)
      end

      private

      def npm(package_name, *args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        options = { development: @development }.merge(options)
        version = args.empty? ? "latest" : args.pop
        export = options.delete(:require) { true }

        package = Npm::Rails::Package.new(package_name, version, options)
        @packages << package
        @exports << package.export if export
      end

      def export(build_name, *args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        options = { development: @development }.merge(options)
        options[:name] = args.pop

        @exports << Npm::Rails::PackageExport.new(build_name, options)
      end

      def development
        @development = true
        yield
        @development = false
      end
    end
  end
end
