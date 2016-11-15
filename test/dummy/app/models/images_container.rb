class ImagesContainer < ActiveRecord::Base
  include Gigantic::ContainerObject

  has_many :images

  def perform_upload_for(request_params)
    params = JSON.parse(request_params)

    params.each do |p_hash|
      Image.create(picture: p_hash, images_container_id: self.id, original_filename: p_hash['original_filename'])
    end

    self.update_attributes(message: "Un nouveau container avec ces images : #{self.images.pluck(:original_filename).join(', ')}")
  end

  def valid_upload_params?(request_params)
    params = JSON.parse(request_params)
    if params
      valid_upload_path?(params.first['relative_path'])
    end
  end

  def valid_upload_path?(relative_path)
    relative_path =~ /^.+$/
  end

  def to_s
    "#{id} : #{self.images.count}"
  end
end
