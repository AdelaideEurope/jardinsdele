class AssistantsController < ApplicationController
  def index
    @assistants = ActsAsTaggableOn::Tag.all
  end
end
