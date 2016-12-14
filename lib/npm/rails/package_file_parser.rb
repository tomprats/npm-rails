module Npm
  module Rails
    class PackageFileParser

      attr_reader :packages
      attr_reader :scopes

      def self.parse(package_file_path)
        parser = new
        parser.parse(package_file_path)
        { packages: parser.packages, scopes: parser.scopes }
      end

      def initialize
        @packages = []
        @scopes = []
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
        required = options.delete(:require) { true }

        package = Npm::Rails::Package.new(package_name, version, options)
        @packages << package
        @scopes << package.scope if required
      end

      def set(build_name, *args)
        options = args.last.is_a?(Hash) ? args.pop : {}
        options = { development: @development }.merge(options)
        options[:name] = args.pop

        @scopes << Npm::Rails::PackageScope.new(build_name, options)
      end

      def development
        @development = true
        yield
        @development = false
      end
    end
  end
end
