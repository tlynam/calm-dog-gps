module ApplicationHelper
  def phone_last_updated(phone)
    if updated_at = phone.try(:location_updated_at)
      "Updated #{time_ago_in_words(updated_at)} ago"
    end
  end
end
