require File.expand_path('../..//config/environment.rb', __FILE__)

interval = RaspberryPi.first.interval

every (interval).minutes do
  rake "calc_dist_play_music"
end
