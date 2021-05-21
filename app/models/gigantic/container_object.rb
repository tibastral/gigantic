module Gigantic::ContainerObject
  extend ActiveSupport::Concern

  def perform_upload_for(request_params, tip=nil)
    raise "perform_upload_for needs to be overriden in #{self.class.name}"
  end

  def valid_upload_params?(request_params, tip=nil)
    raise "valid_upload_params? needs to be overriden in #{self.class.name}"
  end

  def valid_upload_path?(relative_path, tip=nil)
    raise "valid_upload_path? needs to be overriden in #{self.class.name}"
  end

  def invalid_upload_path_message(relative_path, tip)
    raise "invalid_upload_path_message needs to be overriden in #{self.class.name}"
  end

  def valid_relative_path_examples(tip)
    raise "valid_relative_path_examples needs to be overriden in #{self.class.name}"
  end

  class_methods do
    # This method can be overriden if some extra steps need to be perform on creation
    # (like using relative path in request_params items for a name)
    def gigantic_find_or_create_by(gigantic_token:, example_path:, id:)
      if id.present?
        obj = find(id)
        obj.update_attribute(:gigantic_token, gigantic_token) if obj.gigantic_token != gigantic_token
      else
        obj = find_or_create_by(gigantic_token: gigantic_token)
      end
      obj.update_attribute(:gigantic_example_path, example_path) if example_path
      obj
    end
  end

  included do
    has_attachments :lot_of_pictures, accept: [:jpg, :png, :gif]
  end
end
