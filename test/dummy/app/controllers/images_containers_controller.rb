class FooController < ApplicationController

  def index
    @images_containers = ImagesContainer.all
  end

  def create
    raise "bloup"
  end

end
