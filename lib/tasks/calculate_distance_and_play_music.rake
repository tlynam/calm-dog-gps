desc "Play audio if a phone is close to home"

task calc_dist_play_music: :environment do
  Phone.update_locations!

  Phone.all.each do |phone|
    if phone.near_home?
      phone.update_attribute(:is_home, true)
      RaspberryPi.play_music
    end
  end
end
