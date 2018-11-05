require 'rails_helper'

feature 'Delete answer', %(
  In order to delete my answer(s) from community
  as an authenticated user
  i want to be able to delete answers.
) do

  scenario "Author of answer try to delete his answer."

  scenario "Not an author of answer try to delete this answer."

end