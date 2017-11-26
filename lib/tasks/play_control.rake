require 'dropbox'
require 'fileutils'
require 'httparty'
require 'json'


task :test_awesome_closing => :environment do

	puts "This is awesome #{DateTime.now}"
end
