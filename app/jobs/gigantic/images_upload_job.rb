module Gigantic
  class ImagesUploadJob < ActiveJob::Base
    queue_as :default

    def perform(*args)
      gigantic_container = Gigantic.container_class.find args[0]
      gigantic_container.perform_upload_for(args[1])
    end
  end
end
