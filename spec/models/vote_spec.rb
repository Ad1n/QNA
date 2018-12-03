require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should validate_presence_of :score }
  it { should belong_to(:votable) }
  it { should belong_to(:user) }
end
