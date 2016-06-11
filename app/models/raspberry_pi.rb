class RaspberryPi < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name
  validates_numericality_of :volume, :duration
  validates :volume, :inclusion => { :in => 1..100 }

  has_one :home
  has_many :exclusion_zones
  has_many :phones

  accepts_nested_attributes_for :phones, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :exclusion_zones, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :home, reject_if: :all_blank, allow_destroy: true

  after_save :set_volume, if: :volume_changed?

  def play_music
    system("#{audio_player} app/assets/audios/beethoven_sontata_no_14.mp3")
  end

  private

  def set_volume
    if OS.osx?
      # OSX max volume is 7 so using approximate scaling
      adjusted_volume = (volume * 0.75) / 10
      system("osascript -e 'set volume #{adjusted_volume}'")
    elsif OS.linux?
      system("amixer cset numid=1 -- #{volume}%")
    end
  end

  def self.audio_player
    return "aplay" if OS.linux?
    return "afplay" if OS.osx?
    raise "Audio player not configured for this OS"
  end
end
