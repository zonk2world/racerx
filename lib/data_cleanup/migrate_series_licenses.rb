module DataCleanup
  class MigrateSeriesLicenses

    def perform
      ActiveRecord::Base.transaction do
        create_new_licenses
        remove_series_licenses
      end

    end

    private

    def create_new_licenses
      SeriesLicense.all.each do |series_license|
        create_all_race_class_licenses series_license.series,
                                   series_license.user,
                                   series_license.paid
      end
    end

    def create_all_race_class_licenses(series, user, paid)
      series.race_classes.each do |race_class|
        create_race_class_license race_class, user, paid
      end
    end

    def create_race_class_license(race_class, user, paid)
      License.create! user: user,
                      licensable: race_class,
                      paid: paid
    end

    def remove_series_licenses
      SeriesLicense.destroy_all
    end

  end
end
