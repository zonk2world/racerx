require "spec_helper"

describe UserMessages do
  let(:user_message) { UserMessage.new(name: "Hulk", email: "hulk@hogan.com", subject: "Brother", content: "I'm coming after you brother!") }
  let(:mail) { UserMessages.user_message(user_message) }
  
  describe "user_message" do
    it "should send the user_message to the pitcrew email" do
      mail.subject.should eq("Brother")
      mail.to.should eq(['pitcrew@motodynasty.com'])
      mail.from.should eq(['hulk@hogan.com'])
      mail.body.encoded.should match("coming after you brother!")
    end
  end
end
