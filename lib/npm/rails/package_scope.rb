module Npm
  module Rails
    class PackageScope

      attr_reader :name
      attr_reader :build_name

      def initialize(name, options = {})
        @build_name = name
        @development = options.fetch(:development, false)
        @name = options.fetch(:name, create_name_from_build_name)
      end

      def development?
        @development
      end

      private

      def create_name_from_build_name
        @build_name.underscore.dasherize
      end
    end
  end
end
