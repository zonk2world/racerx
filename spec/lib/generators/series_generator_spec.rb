require 'spec_helper'

module Generators
  describe SeriesGenerator do
    describe ".generate" do
      it "should create a new series" do
        generated_series = SeriesGenerator.generate "My Series", 100, 600, 1, 1
        expect(generated_series.name).to eq "My Series"
        expect(generated_series.cost).to eq 600
        expect(generated_series.round_cost).to eq 100
      end

      it "can create a single race class" do
        generated_series = SeriesGenerator.generate "My Series", 100, 600, 1, 1
        expect(generated_series.race_classes.count).to eq 1
        expect(generated_series.race_classes.first.name).to eq "Race Class 1"
      end

      it "can create a number of race classes" do
        generated_series = SeriesGenerator.generate "My Series", 100, 600, 3, 1
        race_classes = generated_series.race_classes
        expect(race_classes.count).to eq 3
        expect(race_classes[0].name).to eq "Race Class 1"
        expect(race_classes[1].name).to eq "Race Class 2"
        expect(race_classes[2].name).to eq "Race Class 3"
      end

      it "can create a single round per race class" do
        generated_series = SeriesGenerator.generate "My Series", 100, 600, 1, 1
        rounds = generated_series.rounds
        expect(rounds.count).to eq 1
        expect(rounds.first.name).to eq "Round 1"
      end

      it "can create a number of rounds per race class" do
        generated_series = SeriesGenerator.generate "My Series", 100, 600, 3, 3
        expect(generated_series.rounds.count).to eq 9

        second_race_class_rounds = generated_series.race_classes[1].rounds
        expect(second_race_class_rounds[0].name).to eq "Round 1"
        expect(second_race_class_rounds[1].name).to eq "Round 2"
        expect(second_race_class_rounds[2].name).to eq "Round 3"
      end

      it "should report empty names" do
        expect { SeriesGenerator.generate "", 100, 600, 1, 1 }.to raise_error(ArgumentError)
      end

      it "should report negative cost arguments" do
        expect { SeriesGenerator.generate "My Series", -30, 1, 1 }.to raise_error(ArgumentError)
      end

      it "should report race class counts of zero" do
        expect { SeriesGenerator.generate "My Series", 100, 600, 0, 1 }.to raise_error(ArgumentError)
      end

      it "should report negative race class counts" do
        expect { SeriesGenerator.generate "My Series", 100, 600, -1, 1 }.to raise_error(ArgumentError)
      end

      it "should report round counts of zero" do
        expect { SeriesGenerator.generate "My Series", 100, 600, 1, 0 }.to raise_error(ArgumentError)
      end

      it "should report negative round counts" do
        expect { SeriesGenerator.generate "My Series", 100, 600, 1, -1 }.to raise_error(ArgumentError)
      end
    end
  end
end
