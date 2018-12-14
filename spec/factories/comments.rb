FactoryBot.define do
  factory :comment do
    body { "Test comment" }
  end

  factory :invalid_comment, class: "Comment" do
    body { nil }
  end
end
