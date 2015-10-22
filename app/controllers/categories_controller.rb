class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])
    @recent_videos = @category.recent_videos
  end
end