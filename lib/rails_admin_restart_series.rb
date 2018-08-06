require 'rails_admin/config/actions'
require 'rails_admin/config/actions/base'
 
module RailsAdmin
  module Config
    module Actions
      class RestartSeries < RailsAdmin::Config::Actions::Base
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
                new_series = Generators::NextSeriesGenerator.start params[:series_id]

                #flash[:notice] = "The seriess has been restarted successfully."
                flash[:notice] = "The seriess has been restarted successfully."
                redirect_to show_path(Series, new_series)
                @action.template_name

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
