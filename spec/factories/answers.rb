FactoryBot.define do
  factory :answer do
    body { "Test answer" }
  end

  factory :invalid_answer, class: "Answer" do
    body { nil }
  end

end
