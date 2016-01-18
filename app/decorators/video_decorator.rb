class VideoDecorator < Draper::Decorator
  delegate_all

  # def rating
  #   object.rating.present? ? "#{object.rating}/5.0" : "N/A"
  # end

  def watch_video(watch_params)
    if watch_params
      h.video_tag(object.video_url, type: "video/mp4", size: "665x375", controls: true, autoplay: true)
    else
      h.image_tag(object.large_cover_url)
    end
  end

  def star_whole
    object.rating.nil? ? 0 : object.rating.floor
  end

  def with_half
    object.rating.ceil > object.rating.floor ? "-half" : "" if object.rating  
  end
end



# @video.rating.nil? ? 0 : @video.rating.floor
# @video.rating.ceil > @video.rating.floor ? "-half" : "" if @video.rating