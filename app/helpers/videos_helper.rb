module VideosHelper
  def render_options_for_select(selected=nil)
    options_for_select([5, 4, 3, 2, 1].map { |number| [pluralize(number, "Star"), number] }, selected)
  end

  def rating_star
    image_tag("/tmp/rating_map.png")
  end
end