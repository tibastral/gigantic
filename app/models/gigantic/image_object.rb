module Gigantic::ImageObject
  extend ActiveSupport::Concern


  def perform_upload_for(request_params)
    # need to be overriden
  end

  included do
    has_attachment :picture
    validates :picture, presence: true

    belongs_to Gigantic.container_object_resource.to_sym
  end
end
