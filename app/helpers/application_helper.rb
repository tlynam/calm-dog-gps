module ApplicationHelper
  def phone_last_updated(phone)
    if updated_at = phone.try(:location_updated_at)
      "Updated #{time_ago_in_words(updated_at)} ago"
    end
  end

  def audio_file_collection
    Dir.glob("app/assets/audios/*").map { |audio|
      name = audio.gsub("app/assets/audios/", "")
      [name.gsub(/\.\w+/i, ""), audio]
    }
  end
end
