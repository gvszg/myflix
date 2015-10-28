module VideosHelper
  def render_options_for_select
    options_for_select([5, 4, 3, 2, 1].map { |number| [pluralize(number, "Star"), number] })
  end
end