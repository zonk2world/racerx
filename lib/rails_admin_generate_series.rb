require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'
 
module RailsAdmin
  module Config
    module Actions
      class GenerateSeries < RailsAdmin::Config::Actions::Base
        RailsAdmin::Config::Actions.register(self)

        register_instance_option :collection do
          true
        end

        register_instance_option :visible? do
          authorized? && bindings[:abstract_model].model_name == "Series"
        end

        register_instance_option :link_icon do
          'icon-plus'
        end

        register_instance_option :http_methods do
          [:get, :post]
        end

        register_instance_option :controller do

          Proc.new do
            if request.get?
              render @action.template_name
            elsif request.post?
              begin
                new_series = Generators::SeriesGenerator.generate params[:series_name],
                                                                  Integer(params[:round_cost]),
                                                                  Integer(params[:cost]),
                                                                  Integer(params[:class_count]),
                                                                  Integer(params[:round_count])
                flash[:notice] = "You have generated a new series!"
                redirect_to show_path(Series, new_series)

              rescue ArgumentError => e
                flash[:error] = e.message
                render @action.template_name
              end
            end
          end

        end
      end
    end
  end
end
