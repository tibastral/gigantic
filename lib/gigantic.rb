require "gigantic/engine"

module Gigantic
  def self.table_prefix
    'gigantic_'
  end

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

    def container_object_resources
      container_object_resource.pluralize
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

    def handle_gigantic_error_message(params)
      error_gigantic_token = params.permit(:error_gigantic_token).delete(:error_gigantic_token)
      if error_gigantic_token && error_gigantic_token =~ /^\d+$/
        error_obj = Gigantic.container_object_class.find_by(gigantic_token: error_gigantic_token)
        "Le dernier upload de vos images a échoué. Sauf erreur de notre part, votre arborescence de fichiers n'est pas correcte#{ " (Par exemple : #{error_obj.gigantic_example_path})" if error_obj}. Merci de vérifier votre arborescence. Si votre problème persiste, n'hésitez pas à contacter l'administrateur."
      end
    end

  end

end
