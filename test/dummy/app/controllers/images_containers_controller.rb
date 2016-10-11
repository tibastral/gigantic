class ImagesContainersController < ApplicationController

  def index
    @images_containers = ImagesContainer.all
  end

  def show
    @images_container = ImagesContainer.find(params[:id])
  end

  def edit
    @images_container = ImagesContainer.find(params[:id])
  end

  def new
    @images_container = ImagesContainer.new
  end

end
