source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.4.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.3'
# Use postgresql as the database for Active Record
gem 'pg', '>= 0.18', '< 2.0'
# Use Puma as the app server
gem 'puma', '~> 3.11'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use ActiveStorage variant
# gem 'mini_magick', '~> 4.8'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

# Faraday - Http requests gem
gem 'faraday'

# Figaro - ENV variable gem
gem 'figaro'

# Polyline to help decode GoogleMaps polylines into long lat coords
gem 'polylines'

# CSV for seeding database
gem 'csv'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'pry'
  gem 'factory_bot_rails'
  gem 'shoulda-matchers'
  gem 'simplecov'
  gem 'vcr'
  gem 'launchy'
  gem 'capybara'
  gem 'rspec-rails'
  gem 'webdrivers'
  gem 'webmock'

  # FIXME: Force bundler to use the beta version of the hashdiff gem
  #        `hashdiff` is a dependency of the `webmock` gem. Feel free to remove
  #        the following line from this Gemfile as soon as hashdiff 1.0.0 is
  #        officially realized.
  # https://stackoverflow.com/questions/57004493/ruby-gem-hashdiff-how-to-upgrade-to-1-0-to-stop-deprecation-warnings
  gem 'hashdiff', '>= 1.0.0.beta1'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
end


# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
