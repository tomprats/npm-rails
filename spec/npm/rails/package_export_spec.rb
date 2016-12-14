require 'spec_helper'

describe Npm::Rails::PackageExport do

  it "creates from build name when there is no name" do
    package = Npm::Rails::PackageExport.new("OriginalBuildName")
    expect(package.name).to eq "original-build-name"
  end
end
