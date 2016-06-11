class ChangeRaspberryPiAudioPathsToString < ActiveRecord::Migration
  def change
    change_column :raspberry_pis, :audio_file_paths, :string
    rename_column :raspberry_pis, :audio_file_paths, :audio_file
  end
end
