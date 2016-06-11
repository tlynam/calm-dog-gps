desc "Play audio if a phone is close to home"

task calc_dist_play_music: :environment do
  Phone.update_locations!

  Phone.play_music_if_near_home
end
