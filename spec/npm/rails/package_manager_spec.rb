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

  let!(:scope_for_all_environment) do
    double(:scope_for_all_environment,
          build_name: "ScopeForAllEnvironment",
          development?: false,
          name: "scope-for-all-environment")
  end

  let!(:scope_for_development) do
    double(:scope_for_development,
          build_name: "ScopeForDevelopment",
          development?: true,
          name: "scope-for-development")
  end

  let(:scopes) do
    [ scope_for_all_environment,
      scope_for_development ]
  end

  let(:production_env) { double(:production_env, production?: true, development?: false) }
  let(:development_env) { double(:development_env, production?: false, development?: true) }

  before do
    allow(File).to receive(:exist?).with("tmp/npm-rails").and_return true
  end

  describe "write_bundle_file" do
    let!(:file_buffer) { stub_file_writing }

    context "for production" do
      it "writes scopes for all environment" do
        Npm::Rails::PackageManager.new(packages, [scope_for_all_environment], "root_path", production_env).write_bundle_file
        expect(file_buffer.string).to match /^window\.ScopeForAllEnvironment = require\('scope-for-all-environment'\)$/
      end

      it "does not write development scopes" do
        Npm::Rails::PackageManager.new(packages, [scope_for_development], "root_path", production_env).write_bundle_file
        expect(file_buffer).to_not match /ScopeForDevelopment/
      end
    end

    context "for development" do
      it "writes scopes for all environment" do
        Npm::Rails::PackageManager.new(packages, [scope_for_all_environment], "root_path", development_env).write_bundle_file
        expect(file_buffer.string).to match /^window\.ScopeForAllEnvironment = require\('scope-for-all-environment'\)$/
      end

      it "writes development scopes" do
        Npm::Rails::PackageManager.new(packages, [scope_for_development], "root_path", development_env).write_bundle_file
        expect(file_buffer.string).to match /^window\.ScopeForDevelopment = require\('scope-for-development'\)$/
      end
    end
  end

  describe "to_npm_format" do
    context "for production" do
      it "returns string with packages for 'npm install' command without development packages" do
        package_manager = Npm::Rails::PackageManager.new(packages, scopes, "root_path", production_env)
        result = "package-for-all-environment@\"1.0.0\" "
        expect(package_manager.to_npm_format).to eq result
      end
    end

    context "for development" do
      it "returns string with all packages for 'npm install ' command" do
        package_manager = Npm::Rails::PackageManager.new(packages, scopes, "root_path", development_env)
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
