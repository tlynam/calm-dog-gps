require File.expand_path('../..//config/environment.rb', __FILE__)

interval = RaspberryPi.first.interval

job_type :rbenv_rake, 'export PATH="$HOME/.rbenv/bin:$PATH"; eval "$(rbenv init -)";
                           cd :path && RAILS_ENV=production bin/rake :task --silent :output'

set :output, "~/cron_log.log"

every interval.minutes do
  rbenv_rake "calc_dist_play_music"
end
