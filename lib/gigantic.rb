require "gigantic/engine"

module Gigantic
  def self.include(base)
    extends(ClassMethods)
  end

  class << self
    attr_accessor :image_object_class_name, :delay_upload, :container_object_class_name

    def container_object_class
      @container_object_class_name.constantize
    end

    def container_object_resource
      @container_object_class_name.underscore
    end

    def image_object_class
      @image_object_class_name.constantize
    end

    def image_object_resource
      @image_object_class_name.underscore
    end

    def image_object_resources
      image_object_resource.pluralize
    end

    def delay_upload?
      defined?(@delay_upload) ? @delay_upload : false
    end

  end

end
