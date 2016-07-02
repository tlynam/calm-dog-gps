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
  after_commit :set_cron, :if => Proc.new { |record|
    record.previous_changes.key?(:interval)
  }

  def play_music
    times_play_audio.times do
      system("#{self.class.audio_player} #{audio_file}")
    end
  end

  private

  def set_volume
    if OS.osx?
      # OSX max volume is 7 so using approximate scaling
      adjusted_volume = (volume * 0.70) / 10
      system("osascript -e 'set volume #{adjusted_volume}'")
    elsif OS.linux?
      system("amixer cset numid=1 -- #{volume}%")
    end
  end

  def set_cron
    # Writing directly to crontab so don't need to load Rails env as it's slow on Pi
    # https://github.com/javan/whenever/blob/19311d828/lib/whenever/command_line.rb#L67

    fail 'Whenever was updated' unless Gem.loaded_specs['whenever'].version.to_s == '0.9.4'
    contents = Whenever::CommandLine.new.send(:updated_crontab)
    IO.popen('crontab -', 'r+') do |crontab|
      crontab.write(contents)
      crontab.close_write
    end
  end

  def self.audio_player
    if OS.osx?
      "afplay"
    elsif OS.linux?
      "omxplayer"
    else
      raise "Audio player not configured for this OS"
    end
  end

  def audio_duration_seconds
    if OS.osx?
      output = `afinfo #{audio_file}`
      duration_str = output.split("\n").find { |data| data.include?("estimated duration") }
      duration_str.match(/\d+/).to_s.to_i
    elsif OS.linux?
      output = `avprobe #{audio_file} 2>&1`
      duration_str = output.split("\n").find { |data| data.include?("Duration:") }
      time_str = duration_str.squish.gsub("Duration: ", "").match(/[0-9:]+/).to_s
      # Hack, duration format is hr:mm:ss so setting it as current time
      Time.parse(time_str) - Time.now.midnight
    end
  end

  def times_play_audio
    duration_seconds = duration * 60
    (duration_seconds / audio_duration_seconds) + 1
  end
end
