require 'spec_helper'
module DataCleanup
  describe MigrateSeriesLicenses do
    subject { MigrateSeriesLicenses.new }

    describe "#perform" do
      let(:race_class_one) { FactoryGirl.create :race_class }
      let!(:race_class_two) { series_one.race_classes.create name: "another race class" }
      let(:series_one) { race_class_one.series }
      let(:user_one) { FactoryGirl.create :user }
      let!(:series_license_one) { FactoryGirl.create :series_license,
                                              user: user_one,
                                              series: series_one }

      let(:race_class_three) { FactoryGirl.create :race_class }
      let(:series_two) { race_class_three.series }
      let(:user_two) { FactoryGirl.create :user }
      let!(:series_license_two) { FactoryGirl.create :series_license,
                                              user: user_two,
                                              series: series_two }

      let!(:unlicensed_user) { FactoryGirl.create :user }

      it "creates a race class License for each race class in a series license" do
        expect(user_one.licenses.count).to eq 0
        subject.perform
        expect(user_one.licenses.count).to eq 2
      end

      it "creates race class Licenses for multiple users" do
        expect(user_two.licenses.count).to eq 0
        subject.perform
        expect(user_two.licenses.count).to eq 1
      end

      it "doesn't create licenses for users without a series license" do
        expect(unlicensed_user.licenses.count).to eq 0
        subject.perform
        expect(unlicensed_user.licenses.count).to eq 0
      end

      it "removes all series licenses" do
        expect(SeriesLicense.count).to eq 2
        subject.perform
        expect(SeriesLicense.count).to eq 0
      end

      describe "in the presence of an error" do
        before do
          @call_count = 0
          allow(License).to receive(:create!) do |args|
            @call_count += 1
            raise RuntimeError if @call_count > 2
            License.create(args)
          end
        end

        it "does not remove series licenses if an error is encountered" do
          expect(SeriesLicense.count).to eq 2
          expect { subject.perform }.to raise_error(RuntimeError)
          expect(SeriesLicense.count).to eq 2
        end

        it "does not create licenses if an error is encountered" do
          expect(License.count).to eq 0
          expect { subject.perform }.to raise_error(RuntimeError)
          expect(License.count).to eq 0
        end
      end
    end

  end
end
