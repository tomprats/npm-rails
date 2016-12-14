require 'spec_helper'

describe Npm::Rails::Package do
  let(:package) { Npm::Rails::Package.new("original-package-name", "1.0.0") }

  it "creates build_name from name when there is no build_name" do
    expect(package.build_name).to eq "OriginalPackageName"
  end

  describe "export" do
    it "creates export with same name" do
      expect(package.export.name).to eq package.name
    end

    it "creates export with same build name" do
      expect(package.export.build_name).to eq package.build_name
    end
  end
end
