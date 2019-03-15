require 'administrate/base_controller/version'
require 'administrate/engine'

module Administrate
  class Engine < Rails::Engine
    config.after_initialize do
      ::Administrate::ApplicationController.class_eval do
        def index
          resources = index_resources
          resources = apply_resource_includes(resources)
          resources = order.apply(resources)
          resources = resources.page(params[:page]).per(records_per_page)
          page = index_page

          render locals: {
              resources: resources,
              search_term: search_term,
              page: page,
              show_search_bar: show_search_bar?,
          }
        end

        def new
          resource = new_resource
          authorize_resource(resource)
          render locals: { page: new_page(resource) }
        end

        def edit
          render locals: { page: edit_page(requested_resource) }
        end

        def show
          render locals: { page: show_page }
        end

        protected

        def search_term
          @search_term ||= params[:search].to_s.strip
        end

        def index_scoped_resource
          scoped_resource
        end

        def index_resources
          Administrate::Search.new(index_scoped_resource, dashboard_class, search_term).run
        end

        def index_page
          Administrate::Page::Collection.new(dashboard, order: order)
        end

        def show_page
          Administrate::Page::Show.new(dashboard, requested_resource)
        end

        def new_page(resource)
          Administrate::Page::Form.new(dashboard, resource)
        end

        def edit_page(resource)
          new_page(resource)
        end

        def authorize_resource(resource)
          return if show_action?(action_name.to_sym, resource)
          raise "That's not a valid action."
        end

        def resource_params
          permitted = params.require(resource_class.model_name.param_key)
                          .permit(dashboard.permitted_attributes)
                          .to_h

          permitted.each_with_object(permitted) do |(k, v), result|
            result[k] = read_param(k, v)
          end
        end

        def read_param(_, data)
          if data.is_a?(ActionController::Parameters) && data[:type]
            return read_param_value(data)
          end

          data
        end

        private

        attr_writer :search_term
      end
    end
  end
end
