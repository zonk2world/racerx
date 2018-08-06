class MergeDivisionsIntoRaceClasses < ActiveRecord::Migration
  class Division < ActiveRecord::Base; end

  def up
    race_class = RaceClass.find_by(name: '250')

    # fix up race classes and rounds
    split_classes = Division.all.map do |division|
      split = race_class.dup
      split.name = "#{race_class.name} #{division.name}"
      split.save!

      Round.where(race_class: race_class, division_id: division.id).update_all race_class_id: split.id

      split
    end

    # split final round
    if race_class.try(:rounds).try(:count) == 1
      final = race_class.rounds.first
      split_final = final.dup

      final.update_attributes race_class: split_classes[0]
      split_final.update_attributes race_class: split_classes[1]
    end

    # shouldn't be any rounds left
    if race_class && race_class.try(:rounds).try(:count) > 0
      raise "Splitting Round was not successfull for #{race_class.rounds.pluck(:id).join(', ')}\n\n"
    end

    race_class.destroy if race_class

    remove_column :user_round_stats, :division_id
    remove_column :rounds, :division_id
    drop_table :divisions

    # recompute scores
    Round.where(finished: true).find_each do |round|
      round.compute_score
    end
  end
end
