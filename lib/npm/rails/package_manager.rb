module Npm
  module Rails
    class PackageManager

      def self.build(root_path, package_file, env)
        package_file_path = "#{ root_path }/#{ package_file }"
        result = PackageFileParser.parse(package_file_path)
        new(result[:packages], result[:scopes], root_path, env)
      end

      def initialize(packages, scopes, root_path, env)
        @packages = packages
        @scopes = scopes
        @root_path = root_path
        @env = env
      end

      def write_bundle_file
        bundle_file_path = "#{ @root_path }/tmp/npm-rails/bundle.js"
        FileUtils.mkdir_p("tmp/npm-rails")
        File.open(bundle_file_path, "w") do |file|
          packages_for(:bundle).each do |package|
            file.write "window.#{ package.build_name } = require('#{ package.name }')\n"
          end
        end
        bundle_file_path
      end

      # Return string of packages for 'npm install' command
      def to_npm_format
        packages_for(:npm).inject "" do |string, package|
          string << "#{ package.name }@\"#{ package.version }\" "
        end
      end

      private

      def packages_for(kind)
        packages = kind == :npm ? @packages : @scopes

        if @env.production?
          packages.select { |package| !package.development? }
        else
          packages
        end
      end
    end
  end
end
