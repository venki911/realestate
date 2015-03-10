require "rails_helper"

RSpec.describe UserMailer, :type => :mailer do
  describe "forgot_password" do
    let(:user) {create(:user)}
    let(:mail) do 
      user.generate_token(:reset_password_token)
      UserMailer.forgot_password(user)
    end

    it "renders the headers" do
      expect(mail.subject).to eq("Reset Password Instruction")
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq([ENV['EMAIL_SUPPORT']])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(user.reset_password_token)
    end
  end

end
