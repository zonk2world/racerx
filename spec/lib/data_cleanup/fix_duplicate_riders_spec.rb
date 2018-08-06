require 'spec_helper'

module DataCleanup
  describe FixDuplicateRiders do
    subject { FixDuplicateRiders.new }

    describe "#perform" do
      let!(:dakota_tedder_one) { FactoryGirl.create :rider,
                                id: 43,
                                name: 'Dakota Tedder',
                                race_number: 83
                              }
      let!(:dakota_tedder_two) { FactoryGirl.create :rider,
                                id: 169,
                                name: 'not a rider',
                                race_number: 83
                              }
      let!(:rider_position_one) { FactoryGirl.create :rider_position,
                                  rider: dakota_tedder_two
                                }
      let!(:valid_round_rider) { FactoryGirl.create :round_rider }
      let!(:invalid_round_rider) { FactoryGirl.create :round_rider}

      context "When duplicate riders have been used in a user prediction" do 

        it "should assign those predictions to the original rider" do
          expect(rider_position_one.rider).to eq dakota_tedder_two
          subject.perform
          expect(rider_position_one.reload.rider).to eq dakota_tedder_one
        end

        it "should remove the duplicate rider" do
          expect(Rider.find 169).to eq dakota_tedder_two
          subject.perform
          expect { Rider.find 169 }.to raise_error
        end

      end

      context "When round rider associations exist without valid rounds" do

        before(:each) do
          # Set the invalid round rider's round ID to null
          # (bypassing the new model validations)
          ActiveRecord::Base.connection.execute("UPDATE round_riders SET round_id=null WHERE id=#{invalid_round_rider.id}") 
        end

        it "should remove the invalid rounds" do
          subject.perform
          expect(RoundRider.find valid_round_rider.id).to eq valid_round_rider
          expect { RoundRider.find invalid_round_rider.id }.to raise_error
        end
      end

    end

  end
end
