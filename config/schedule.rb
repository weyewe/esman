# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
# every 5.minutes do
#   # runner "MyModel.some_process"
#   rake "post_to_dropbox"
#   # command "/usr/bin/my_great_command"
# end


set :output, "/var/www/sableng.com/cron_log/error.log"

every 1.day, :at => '1pm' do
  rake "generate_weekly_collection_report_for_tomorrow_and_post_to_dropbox"
end
