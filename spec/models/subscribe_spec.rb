require 'rails_helper'

RSpec.describe Subscribe, type: :model do
  it { should belong_to(:subscribable) }
  it { should belong_to(:user) }
end
