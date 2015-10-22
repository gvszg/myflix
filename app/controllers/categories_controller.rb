class CategoriesController < ApplicationController
  before_action :require_user
  
  def show
    @category = Category.find(params[:id])
    @recent_videos = @category.recent_videos
  end
end