module Gigantic::ImageObject
  extend ActiveSupport::Concern


  def perform_upload_for(request_params)
    # need to be overriden
  end

  included do
    has_attachment :picture
    validates :picture, presence: true

  end
end
