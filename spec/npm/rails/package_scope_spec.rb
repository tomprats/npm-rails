require 'spec_helper'

describe Npm::Rails::PackageScope do

  it "creates from build name when there is no name" do
    package = Npm::Rails::PackageScope.new("OriginalBuildName")
    expect(package.name).to eq "original-build-name"
  end
end
