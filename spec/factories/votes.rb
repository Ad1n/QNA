FactoryBot.define do
  factory :vote do
    score { 1 }
  end

  factory :unvote, class: "Vote" do
    score { -1 }
  end
end
