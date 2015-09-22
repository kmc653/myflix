class VideosController < ApplicationController
  before_action :require_user

  def index
    @videos = Video.all
    @categories = Category.all
  end

  def show
    @video = VideoDecorator.decorate(Video.find_by id: params[:id])
    @reviews = @video.reviews
  end

  def search
    if params[:search_term].present?
      @results = Video.search(params[:search_term])
    else
      @results = Video.all
    end
  end
end