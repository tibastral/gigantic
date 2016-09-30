require "simple_form"
require "cloudinary"
require "attachinary"
require "attachinary/orm/active_record"

module Gigantic
  class Engine < ::Rails::Engine
    isolate_namespace Gigantic

    config.active_job.queue_adapter = :sidekiq
  end

end

