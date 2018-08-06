module Generators
  class NextSeriesGenerator
    attr_reader :series_id

    def initialize(series_id)      
      @pre_series = Series.find(series_id)
      @race_class_count = 3
      @round_count = 16
    end

    def start
      raise ArgumentError, "Previous series is not available." unless @pre_series      
      raise ArgumentError, "This series is not complete." unless @pre_series.Complete
      
      new_series = create_series
      create_series_license new_series
      generate_race_classes new_series

      new_series
    end

    private

    def create_series
      name = "#{Date.today.year} #{@pre_series.name}"
      previous_ids = @pre_series.previous_ids
      previous_ids << @pre_series.id
      Series.create! name: name, cost: @pre_series.cost, round_cost: @pre_series.round_cost, previous_ids: previous_ids
    end
    
    def create_series_license(new_series)
      @pre_series.series_licenses.each do |sl|
        SeriesLicense.create! series_id: new_series.id, user_id: sl.user_id, paid: sl.paid
      end
    end

    def create_race_class(series, race_class)      
      series.race_classes.create! name: race_class.name
    end

    def create_round(race_class, round, round_number)
      new_round = race_class.rounds.create! name: round.name,
                                start_time: (round_number + 2).weeks.from_now,
                                end_time: (round_number + 3).weeks.from_now
      create_round_riders new_round, round
    end

    def create_empty_round(new_race_class, round_number)
      new_race_class.rounds.create! name: "Round #{round_number}",
                                start_time: (round_number + 2).weeks.from_now,
                                end_time: (round_number + 3).weeks.from_now
    end

    def generate_empty_rounds(new_race_class)      
      @round_count.times do |round_index|
        create_empty_round new_race_class, round_index + 1
      end
    end

    def generate_race_classes(series)
      @pre_series.race_classes.each do |race_class|      
        new_race_class = create_race_class series, race_class
        generate_rounds new_race_class, race_class
      end
    end

    def generate_rounds(new_race_class, race_class)      
      if race_class.rounds.length == 0
        generate_empty_rounds new_race_class
      end
      race_class.rounds.each_with_index do |round, round_number|
        create_round new_race_class, round, round_number
      end
    end

    def create_round_riders new_round, old_round
      old_round.round_riders.each do |round_rider|
        new_round.round_riders.create! rider_id: round_rider.rider_id        
      end
    end

    def self.start(series_id)
      generator = NextSeriesGenerator.new series_id
      generator.start
    end

  end
end
