class VideoDecorator < Draper::Decorator
  delegate_all

  def rating
    object.rating.present? ? "#{object.rating}/5.0" : "N/A"
  end

  def watch_video(watch_params)
    if watch_params
      h.video_tag(object.video_url, type: "video/mp4", size: "665x375", controls: true, autoplay: true)
    else
      h.image_tag(object.large_cover_url)
    end
  end
end