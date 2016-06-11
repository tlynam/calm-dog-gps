class RaspberryPi < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_numericality_of :volume, :duration

  has_one :home
  has_many :exclusion_zones
  has_many :phones

  accepts_nested_attributes_for :phones, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :exclusion_zones, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :home, reject_if: :all_blank, allow_destroy: true

  def self.play_music
    system("#{audio_player} app/assets/audios/furelise.mp3")
  end

  private

  def self.audio_player
    return "aplay" if OS.linux?
    return "afplay" if OS.osx?
    raise "Audio player not configured for this OS"
  end
end
