# npm-rails

NPM support for Rails projects. It let you use Bundler-like DSL and rake tasks
for including npm packages. This gem based on Browserify for bundling packages
and resolve dependencies.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'npm-rails'
```

Then run:

    rails g npm_rails:initialize

And require `npm-dependencies.js`:

    //=require npm-dependencies

## Usage

1. Add a package to `npm_packages` file
2. Run `rake npm:install`
3. Use the package in your javascript code by calling the camelize name
or `build_name` if you set it

**Example `npm_packages` file**

```ruby
# call 'React' in your js code to use it
npm 'react'

# Set version
npm 'redux', '3.3.1'

# Set build_name to a package.
# Call '_' to get Underscore
npm 'underscore', build_name: '_'

# You can add a package for development
npm 'jasmine', development: true

# Or in block
development do
  npm 'jasmine'
end

# Install a package but do not require it
npm 'browserify', require: false
```

## Configuration Options

The following options are available for configuration in your application or environment-level
config files (`config/application.rb`, `config/environments/development.rb`, etc.):

| Configuration Option            | Description                                                                                                                                  |
|---------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------- |
| `config.npm.package_file`       | Specificies a package file. Default value: `npm_packages`                                                                                    |
| `config.npm.output_file`        | Specifies a file where to bundle npm packages. Default value: `vendor/assets/javascripts/npm-dependencies.js`.                               |
| `config.npm.browserify_options` | Sets options for browserify command. See all available options in [Browserify documentation](https://github.com/substack/node-browserify#usage) |

## How it works

The generator creates `npm_packages` file. This file contains a list of packages. Rake uses NPM to install the packages and Browserify to bundle them and output the bundled results to `vendor/assets/javascripts/npm-dependencies.js`, which are then loaded by sprockets. These generated bundle file have been added to your `.gitignore` for your convenience. All packages attached to `window`.



