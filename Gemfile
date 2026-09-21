source "https://rubygems.org"

# Only the two Rails frameworks this API needs, instead of the full "rails" gem.
gem "railties", "~> 7.2.3"
gem "actionpack", "~> 7.2.3"
gem "puma", ">= 5.0"

# Rails 7.2's JSON encoder is incompatible with the json gem 3.x (quirks_mode was removed).
gem "json", "~> 2.7"

group :development, :test do
  gem "rspec-rails", "~> 7.1"
  gem "rswag-specs"
end

group :development do
  # bin/rails generate dockerfile
  gem "dockerfile-rails", ">= 1.7"
end
