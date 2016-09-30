class Image < ActiveRecord::Base
  include Gigantic::ImageObject

  def to_s
    self.message || "Nothing to see"
  end

end
