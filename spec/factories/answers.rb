FactoryBot.define do
  sequence :body do |b|
    "Test answer #{b}"
  end

  factory :answer do
    body
  end

  factory :invalid_answer, class: "Answer" do
    body { nil }
  end

end
