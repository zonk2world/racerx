module Generators
  class SeriesGenerator
    attr_reader :name,
                :cost,
                :round_cost,
                :race_class_count,
                :round_count

    def initialize(name, round_cost, cost, race_class_count, round_count)
      @name = name
      @cost = cost
      @round_cost = round_cost
      @race_class_count = race_class_count
      @round_count = round_count
    end

    def generate
      raise ArgumentError, "Name may not be blank" if name.empty?
      raise ArgumentError, "Cost must be a greater than or equal to zero." if cost < 0
      raise ArgumentError, "Number of race classes must be greater than zero." if race_class_count < 1
      raise ArgumentError, "Number of rounds must be greater than zero." if round_count < 1

      new_series = create_series
      generate_race_classes new_series

      new_series
    end

    private

    def create_series
      Series.create! name: name, cost: cost, round_cost: round_cost
    end

    def create_race_class(series, class_number)
      series.race_classes.create! name: "Race Class #{class_number}"
    end

    def create_round(race_class, round_number)
      race_class.rounds.create! name: "Round #{round_number}",
                                start_time: (round_number + 2).weeks.from_now,
                                end_time: (round_number + 3).weeks.from_now
    end

    def generate_race_classes(series)
      race_class_count.times do |class_index|
        new_race_class = create_race_class series, class_index + 1
        generate_rounds new_race_class
      end
    end

    def generate_rounds(race_class)
      round_count.times do |round_index|
        create_round race_class, round_index + 1
      end
    end

    def self.generate(name, round_cost, cost, race_class_count, round_count)
      generator = SeriesGenerator.new name, round_cost, cost, race_class_count, round_count
      generator.generate
    end
  end
end
