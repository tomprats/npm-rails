require 'spec_helper'

describe Npm::Rails::PackageManager do
  let!(:package_for_all_environment) do
    double(:package_for_all_environment,
          name: "package-for-all-environment",
          development?: false,
          build_name: "PackageForAllEnvironment",
          version: "1.0.0")
  end

  let!(:package_for_development) do
    double(:package_for_development,
          name: "package-for-development",
          development?: true,
          build_name: "PackageForDevelopment",
          version: "1.0.0")
  end

  let(:packages) do
    [ package_for_all_environment,
      package_for_development ]
  end

  let!(:export_for_all_environment) do
    double(:export_for_all_environment,
          build_name: "ExportForAllEnvironment",
          development?: false,
          name: "export-for-all-environment")
  end

  let!(:export_for_development) do
    double(:export_for_development,
          build_name: "ExportForDevelopment",
          development?: true,
          name: "export-for-development")
  end

  let(:exports) do
    [ export_for_all_environment,
      export_for_development ]
  end

  let(:production_env) { double(:production_env, production?: true, development?: false) }
  let(:development_env) { double(:development_env, production?: false, development?: true) }

  before do
    allow(File).to receive(:exist?).with("tmp/npm-rails").and_return true
  end

  describe "write_bundle_file" do
    let!(:file_buffer) { stub_file_writing }

    context "for production" do
      it "writes exports for all environment" do
        Npm::Rails::PackageManager.new(packages, [export_for_all_environment], "root_path", production_env).write_bundle_file
        expect(file_buffer.string).to match /^window\.ExportForAllEnvironment = require\('export-for-all-environment'\)$/
      end

      it "does not write development exports" do
        Npm::Rails::PackageManager.new(packages, [export_for_development], "root_path", production_env).write_bundle_file
        expect(file_buffer).to_not match /ExportForDevelopment/
      end
    end

    context "for development" do
      it "writes exports for all environment" do
        Npm::Rails::PackageManager.new(packages, [export_for_all_environment], "root_path", development_env).write_bundle_file
        expect(file_buffer.string).to match /^window\.ExportForAllEnvironment = require\('export-for-all-environment'\)$/
      end

      it "writes development exports" do
        Npm::Rails::PackageManager.new(packages, [export_for_development], "root_path", development_env).write_bundle_file
        expect(file_buffer.string).to match /^window\.ExportForDevelopment = require\('export-for-development'\)$/
      end
    end
  end

  describe "to_npm_format" do
    context "for production" do
      it "returns string with packages for 'npm install' command without development packages" do
        package_manager = Npm::Rails::PackageManager.new(packages, exports, "root_path", production_env)
        result = "package-for-all-environment@\"1.0.0\" "
        expect(package_manager.to_npm_format).to eq result
      end
    end

    context "for development" do
      it "returns string with all packages for 'npm install ' command" do
        package_manager = Npm::Rails::PackageManager.new(packages, exports, "root_path", development_env)
        result = "package-for-all-environment@\"1.0.0\" package-for-development@\"1.0.0\" "
        expect(package_manager.to_npm_format).to eq result
      end
    end
  end

  def stub_file_writing
    StringIO.new.tap do |buffer|
      allow(File).to receive(:open).and_yield(buffer)
    end
  end
end
