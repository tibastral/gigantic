module Gigantic::ContainerObject
  extend ActiveSupport::Concern

  def perform_upload_for(request_params)
    raise "perform_upload_for needs to be overriden in #{self.class_name}"
  end

  def valid_upload_params?(request_params)
    raise "valid_upload_params? needs to be overriden in #{self.class_name}"
  end

  class_methods do
    # This method can be overriden if some extra steps need to be perform on creation
    # (like using relative path in request_params items for a name)
    def gigantic_create_for(gigantic_token: gigantic_token)
      find_or_create_by(gigantic_token: gigantic_token)
    end
  end

  included do
    has_attachments :lot_of_pictures, accept: [:jpg, :png, :gif]
    has_many Gigantic.image_object_resources.to_sym
  end
end
