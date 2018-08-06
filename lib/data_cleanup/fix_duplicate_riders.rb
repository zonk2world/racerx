module DataCleanup
  class FixDuplicateRiders
    def perform
      reassign_predictions_for_duplicates
      remove_round_rider_results_without_rounds

      # (Nick) I haven't found any duplicate round rider results
      # in current production, so I've commented this out temporarily.
      #remove_duplicate_rider_results

    end

    private

    def reassign_predictions_for_duplicates
     # Two copies of rider Dakota Tedder
     original_dakota = Rider.find(43)
     duplicate_dakota = Rider.find(169)

     RiderPosition.where(rider: duplicate_dakota).each do |rp|
       rp.rider = original_dakota
       rp.save!
     end

     RoundRider.where(rider: duplicate_dakota).destroy_all

     duplicate_dakota.destroy
    end

    def remove_round_rider_results_without_rounds
     RoundRider.where(round_id: nil).destroy_all
    end

    def remove_duplicate_rider_results
      rider1 = Rider.find(43)  #Dakota Tedder
      rider3 = Rider.find(106) #Colton Keeling
      rider4 = Rider.find(170) #Billy Carpenter
      rounds = RaceClass.find(4).rounds 

      rounds.each do |round|
        rr1 = RoundRider.where(round: round, rider: rider1)
        rr2 = RoundRider.where(round: round, rider: rider3)
        rr3 = RoundRider.where(round: round, rider: rider4)

        while rr1.count > 1
          rr1.last.destroy
        end

        while rr2.count > 1
          rr2.last.destroy
        end

        while rr3.count > 1
          rr3.last.destroy
        end
      end
    end

  end
end
