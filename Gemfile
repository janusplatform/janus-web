source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'dotenv-rails', :require => 'dotenv/rails-now'
gem 'foreman'

gem 'rails', '~> 5.1.5'
gem 'puma', '~> 3.7'

gem 'mongoid', '~> 6.1.1'
gem 'will_paginate_mongoid'

gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'therubyracer', platforms: :ruby
gem "autoprefixer-rails"

gem 'devise'
gem 'simple_form'

gem 'rails_serve_static_assets', group: [:production, :staging]

gem 'lograge'

gem "less-rails-bootstrap"
gem 'font-awesome-less'
gem "bower-rails"

gem 'sidekiq'

group :development, :test do
end

group :development do
  gem 'listen'
  gem 'spring'
end
