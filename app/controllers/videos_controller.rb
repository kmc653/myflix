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
    if params[:search].present?
      @results = Video.search(params[:search]).records.to_a
    else
      @results = Video.all
    end
  end

  def advanced_search
    if params[:query].present?
      @videos = Video.search(params[:query]).records.to_a
    else
      @videos = []
    end
  end
end