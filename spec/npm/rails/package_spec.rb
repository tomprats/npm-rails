require 'spec_helper'

describe Npm::Rails::Package do
  let(:package) { Npm::Rails::Package.new("original-package-name", "1.0.0") }

  it "creates build_name from name when there is no build_name" do
    expect(package.build_name).to eq "OriginalPackageName"
  end

  describe "set" do
    it "creates scope with same name" do
      expect(package.scope.name).to eq package.name
    end

    it "creates scope with same build name" do
      expect(package.scope.build_name).to eq package.build_name
    end
  end
end
