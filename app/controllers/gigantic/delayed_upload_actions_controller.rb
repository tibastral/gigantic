module Gigantic
  class DelayedUploadActionsController < ApplicationController
    def index
      @delayed_upload_actions = Gigantic::DelayedUploadAction.all
    end
  end
end