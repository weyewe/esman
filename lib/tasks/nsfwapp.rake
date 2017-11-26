require 'dropbox'
require 'fileutils'
require 'httparty'
require 'json'


task :try_nsfwapp_sub_reddits => :environment do




  response = HTTParty.get( "http://nsfwapp-weyewe1.c9.io/api2/sub_reddits" ,
    {
      :body => {
        :user_login => { :email => "willy@gmail.com", :password => "willy1234" }
      }
    })

  server_response =  JSON.parse(response.body )

  puts "the response"
  puts server_response

end

task :try_nsfwapp_images => :environment do




  response = HTTParty.get( "http://nsfwapp-weyewe1.c9.io/api2/images?parent_id=3" ,
    {
      :body => {
        :user_login => { :email => "willy@gmail.com", :password => "willy1234" }
      }
    })

  server_response =  JSON.parse(response.body )

  puts "the response"
  puts server_response

end
