if Rails.env.production? 
	java_home = '/usr/lib/jvm/java-7-openjdk-amd64'
	if Dir.exist?(java_home)
		puts "This is the god-damned java home"
		ENV['JAVA_HOME'] = java_home 
	else
		puts "java home doesn't exists"
	end


end




source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.1.2'

# Use postgresql as the database for Active Record
gem 'pg'
gem 'whenever', :require => false
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

gem 'mina'
gem 'mina-unicorn',    :require => false
gem 'unicorn'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

gem 'rubyXL'

gem 'simple_form'
gem "redis", "~> 3.0.1"
gem "hiredis", "~> 0.4.5"


gem 'wicked_pdf'
gem 'dropbox-sdk'
gem 'httparty'
gem 'json'
gem 'rjb'
gem 'pdf-merger'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'


gem 'thin'
gem 'roadie' # for sending email 's css
gem 'roadie-rails'


# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end


gem 'devise'
gem "kaminari"  
gem 'uuidtools'

gem 'bootstrap-sass', '~> 2.3.1.0'
# gem 'the_role' #, '~> 2.5.2'
# gem 'the_role_bootstrap3_ui'
# gem 'the_role', '~> 3.0.0'

gem 'the_role_api', '~> 3.0.0'
gem 'protected_attributes', '~> 1.0.5'
gem 'delayed_job_active_record'
# gem 'squeel', :git => "git://github.com/activerecord-hackery/squeel.git"
 
# https://github.com/activerecord-hackery/squeel.git
group :production do
  gem 'rails_12factor'
end

# gem 'rails_log_stdout',           github: 'Heroku/rails_log_stdout'
# gem 'rails3_serve_static_assets', github: 'Heroku/rails3_serve_static_assets'

group :development, :test do
  gem 'rspec-rails', '~> 2.0'
  
end


# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]
