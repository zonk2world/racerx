
namespace :motodynasty do
  desc "clear scores"
  task :clear_scores => :environment do    
    User.find_each do |user|
      user.update_attribute(:point_total, 0)
      user.rider_positions.where('score > 0').each do |rp|
        rp.score = 0
        rp.save
      end
    end
  end

  desc "clear nil rider positions"
  task :clear_nil_rider_positions => :environment do    
    RiderPosition.where(position: nil).find_each do |rp|
      rp.destroy
    end
  end

  desc "recompute_scores"
  task :recompute_scores => :environment do
    Round.where(finished: true).find_each do |round|
      round.compute_score
    end
  end

end

## NEED to verify this will fix the issue and not lose any data
 namespace :motodynasty do
   desc "fix duplicate riders"
   task :fix_duplicate_riders => :environment do
     DataCleanup::FixDuplicateRiders.new.perform
   end
 end

 namespace :motodynasty do
   desc "fix duplicate riders"
   task :migrate_series_licenses => :environment do
     DataCleanup::MigrateSeriesLicenses.new.perform
   end
 end
