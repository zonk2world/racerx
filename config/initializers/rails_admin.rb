# RailsAdmin config file. Generated on December 17, 2013 09:25
# See github.com/sferik/rails_admin for more informations
require 'rails_admin_generate_series'
require 'rails_admin_restart_series'


RailsAdmin.config do |config|
  ################  Global configuration  ################

  config.authorize_with :cancan

  config.actions do
    # root actions
    dashboard                     # mandatory

    # collection actions 
    index                         # mandatory
    new
    export
    history_index
    bulk_delete
    generate_series
    restart_series
    # member actions
    show
    edit
    delete
    history_show
    show_in_app
  end

  # Set the admin name here (optional second array element will appear in red). For example:
  config.main_app_name = ['Moto Dynasty', 'Admin']
  # or for a more dynamic name:
  # config.main_app_name = Proc.new { |controller| [Rails.application.engine_name.titleize, controller.params['action'].titleize] }

  # RailsAdmin may need a way to know who the current user is]
  config.current_user_method { current_user } # auto-generated

  # If you want to track changes on your models:
  # config.audit_with :history, 'User'

  # Or with a PaperTrail: (you need to install it first)
  # config.audit_with :paper_trail, 'User'

  # Display empty fields in show views:
  # config.compact_show_view = false

  # Number of default rows per-page:
  # config.default_items_per_page = 20

  # Exclude specific models (keep the others):
  config.excluded_models = ['RiderPosition', 'Point', 'License']

  # Include specific models (exclude the others):
  # config.included_models = ['User']

  # Label methods for model instances:
  # config.label_methods << :description # Default is [:name, :title]


  ################  Model configuration  ################

  # Each model configuration can alternatively:
  #   - stay here in a `config.model 'ModelName' do ... end` block
  #   - go in the model definition file in a `rails_admin do ... end` block

  # This is your choice to make:
  #   - This initializer is loaded once at startup (modifications will show up when restarting the application) but all RailsAdmin configuration would stay in one place.
  #   - Models are reloaded at each request in development mode (when modified), which may smooth your RailsAdmin development workflow.


  # Now you probably need to tour the wiki a bit: https://github.com/sferik/rails_admin/wiki
  # Anyway, here is how RailsAdmin saw your application's models when you ran the initializer:

  config.model 'Payment' do
    field :user
    field :amount
    field :description
    field :created_at
  end

  config.model 'Round' do
    object_label_method do
      :custom_round_label
    end
    field :name
    field :race_class
    field :series do
      read_only true
    end
    field :start_time do
      label 'Rider Selection Start Time (EST)'
    end
    field :end_time do
      label 'Rider Selection End Time (EST)'
    end

    field :finished

    edit do
      field :name
      field :race_class
      field :finished
      
      field :start_time do
        label 'Rider Selection Start Time (EST)'
      end

      field :end_time do
        label 'Rider Selection End Time (EST)'
      end

      field :pole_position_start do
        label 'Pole Position Selection Start Time (EST)'
      end
      field :pole_position_end do
        label 'Pole Position Selection End Time (EST)'
      end

      field :round_riders do 
        label 'Finishing position'
      end

      field :riders
      field :round_bonus_winners
    end
  end

  def custom_round_label
    "#{self.name} #{self.race_class.name}"
  end

  config.model 'Rider' do
    list do 
      sort_by :name
    end
    field :name
    field :race_number
    field :team
  end

  config.model 'User' do
    object_label_method do
      :custom_user_label
    end

    edit do 
      field :name
      field :email
      field :address_1
      field :address_2
      field :admin
      field :point_total
      field :credits
      field :series_licenses
    end
  end

  def custom_user_label
    "#{self.email}"
  end

  config.model 'RoundRider' do
    visible false
    object_label_method do
      :custom_round_rider_label
    end

    edit do
      field :round 
      field :rider
      field :finished_position
    end
  end

  def custom_round_rider_label
    "#{self.rider.name} for #{self.round.name}"
  end

  config.model 'Series' do
    edit do
      field :name
      field :cost do
        label 'Race Class License Cost (In Cents)'
      end
      field :round_cost do
        label 'Individual Round License Cost (In Cents)'
      end
      field :race_classes
      field :rounds
      field :series_licenses
      field :users
    end
  end

  config.model 'SeriesLicense' do
    field :series
    field :user
    
    edit do
      # field :total_score
      # field :total_450_score 
      # field :total_250_west_score
      # field :total_250_east_score
      # field :avg_score
      # field :avg_450_score
      # field :avg_250_west_score
      # field :avg_250_east_score
      # field :rank
    end
  end

  config.model 'RoundBonusWinner' do
    visible false
  end

  config.model 'UserRoundStat' do
    visible false
  end

  config.model 'UserRoundBonusSelection' do
    visible false
  end

  config.model RaceClass do
    field :name
    field :series
    field :rounds
  end

  config.model Setting do
    visible true
  end

  ###  User  ###

  # config.model 'User' do

  #   # You can copy this to a 'rails_admin do ... end' block inside your user.rb model definition

  #   # Found associations:



  #   # Found columns:

  #     configure :id, :integer 
  #     configure :email, :string 
  #     configure :password, :password         # Hidden 
  #     configure :password_confirmation, :password         # Hidden 
  #     configure :reset_password_token, :string         # Hidden 
  #     configure :reset_password_sent_at, :datetime 
  #     configure :remember_created_at, :datetime 
  #     configure :sign_in_count, :integer 
  #     configure :current_sign_in_at, :datetime 
  #     configure :last_sign_in_at, :datetime 
  #     configure :current_sign_in_ip, :string 
  #     configure :last_sign_in_ip, :string 
  #     configure :created_at, :datetime 
  #     configure :updated_at, :datetime 

  #   # Cross-section configuration:

  #     # object_label_method :name     # Name of the method called for pretty printing an *instance* of ModelName
  #     # label 'My model'              # Name of ModelName (smartly defaults to ActiveRecord's I18n API)
  #     # label_plural 'My models'      # Same, plural
  #     # weight 0                      # Navigation priority. Bigger is higher.
  #     # parent OtherModel             # Set parent model for navigation. MyModel will be nested below. OtherModel will be on first position of the dropdown
  #     # navigation_label              # Sets dropdown entry's name in navigation. Only for parents!

  #   # Section specific configuration:

  #     list do
  #       # filters [:id, :name]  # Array of field names which filters should be shown by default in the table header
  #       # items_per_page 100    # Override default_items_per_page
  #       # sort_by :id           # Sort column (default is primary key)
  #       # sort_reverse true     # Sort direction (default is true for primary key, last created first)
  #     end
  #     show do; end
  #     edit do; end
  #     export do; end
  #     # also see the create, update, modal and nested sections, which override edit in specific cases (resp. when creating, updating, modifying from another model in a popup modal or modifying from another model nested form)
  #     # you can override a cross-section field configuration in any section with the same syntax `configure :field_name do ... end`
  #     # using `field` instead of `configure` will exclude all other fields and force the ordering
  # end

end
