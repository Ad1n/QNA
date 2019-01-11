require "rails_helper"

RSpec.describe User, type: :model do

  describe "Associations" do
    it { should have_many(:questions) }
    it { should have_many(:answers) }
    it { should have_many(:votes) }
    it { should have_many(:authorizations) }
  end

  describe "Validations" do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
  end

  describe '#author_of?' do
    let(:user) { create(:user) }
    let(:another_user) { create(:user) }
    let(:question) { create(:question, user: user) }

    it 'returns true for author' do
      expect(user).to be_author_of(question)
    end

    it 'returns false for non author' do
      expect(another_user).to_not be_author_of(question)
    end
  end

  describe ".find_for_oauth" do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: "vkontakte", uid: "123456") }

    context "User has already authorized" do
      it "returns the user" do
        user.authorizations.create(provider: "vkontakte", uid: "123456")
        expect(User.find_for_oauth(auth)).to eq user
      end
    end

    context "User has no authorization" do

      context "App do not return user's email" do
        let(:auth) { OmniAuth::AuthHash.new(provider: :github, uid: "123456", info: { email: nil }) }

        it "returns created default user" do
          default_user = User.find_for_oauth(auth)
          expect(default_user.email).to eq "unconfirmed@user.wait"
          expect(User.last).to eq default_user
        end
      end

      context "user has already exist" do
        let(:auth) { OmniAuth::AuthHash.new(provider: "vkontakte", uid: "123456", info: { email: user.email }) }

        it "doesnt create new user" do
          expect { User.find_for_oauth(auth) }.to_not change(User, :count)
        end

        it "creates authorization for user" do
          expect { User.find_for_oauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it "creates authorization with provider and uid" do
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it "returns the user" do
          expect(User.find_for_oauth(auth)).to eq user
        end
      end

      context "user doesnt exist" do
        let(:auth) { OmniAuth::AuthHash.new(provider: "vkontakte", uid: "123456", info: { email: "new@mail.ru" }) }

        it "creates new user" do
          expect{ User.find_for_oauth(auth) }.to change(User, :count).by(1)
        end

        it "returns new user" do
          expect(User.find_for_oauth(auth)).to be_a(User)
        end

        it "fills user email" do
          user = User.find_for_oauth(auth)
          expect(user.email).to eq auth.info.email
        end

        it "creates authorization" do
          user = User.find_for_oauth(auth)
          expect(user.authorizations).to_not be_empty
        end

        it "creates authorization with correct provider and uid" do
          authorization = User.find_for_oauth(auth).authorizations.first
          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  end
end