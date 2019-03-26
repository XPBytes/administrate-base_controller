require 'administrate/base_controller/version'
require 'administrate/engine'

require_relative '../base_controller'

module Administrate
  class Engine < Rails::Engine
    config.after_initialize do
      ::Administrate::ApplicationController.class_eval do
        include BaseController
      end
    end
  end
end
