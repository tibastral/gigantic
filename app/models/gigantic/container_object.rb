module Gigantic::ContainerObject
  extend ActiveSupport::Concern

  def perform_upload_for(request_params)
    raise "perform_upload_for needs to be overriden in #{this.class_name}"
  end

  included do
    has_attachments :lot_of_pictures, accept: [:jpg, :png, :gif]
    has_many Gigantic.image_object_resources.to_sym
  end
end
