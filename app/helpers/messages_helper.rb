module MessagesHelper
  def facebook_time_format(from_time, to_time = Time.now, include_seconds = false)
    append_text = (from_time >= to_time) ? "from now" : "ago"
    if from_time.to_date == to_time.to_date
      return distance_of_time_in_words(from_time, to_time, include_seconds) + " #{append_text}"
    elsif from_time.year == to_time.year
      if from_time.strftime("%U") == to_time.strftime("%U")
        return from_time.strftime("%a at %I:%M%p")
      else
        return from_time.strftime("%B %d at %I:%M%p")
      end
    else
      return from_time.strftime("%B %d, %Y at %I:%M%p")
    end
  end
end
