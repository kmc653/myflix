class VideosController < ApplicationController
  def index
    @videos = Video.all
    @categories = Category.all
  end

  def show
    @video = Video.find_by title: params[:title]
  end
end