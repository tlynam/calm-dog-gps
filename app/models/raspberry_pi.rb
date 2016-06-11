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
    system("afplay app/assets/audios/furelise.mp3")
  end
end
