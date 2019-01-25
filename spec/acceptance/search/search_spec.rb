require_relative '../acceptance_helper'
require 'rake'
require 'thinking_sphinx/tasks'

feature 'Searching','
  As an user
  I want to be able to find information
' do

  given!(:user)  { create(:user, email: "test@user.email", admin: true) }
  given!(:question)  { create(:question, user: user, body: 'test') }
  given!(:answer)    { create(:answer, question: question, user: user, body: 'test') }
  given!(:comment) { create(:comment, commentable: question, user: user, body: 'test') }

  before do
    user.confirm
    sign_in(user)
  end

  %w[Questions Answers Comments Users All].each do |klass|

    scenario "Try to find in #{klass}", js: true do

      ThinkingSphinx::Test.run do

        ThinkingSphinx::Test.index

        visit root_path

        within ".search-link" do
          click_on "Search"
        end

        within("#search_panel") do
          expect(page).to have_button 'Search'
          fill_in 'query', with: 'test'
          click_on klass
          click_on 'Search'
        end

        expect(current_path).to eq search_path

        case klass
        when "Questions"
          %i[id title body created_at updated_at user_id].each do |attr|
            expect(page).to have_content(question.send(attr))
          end
        when "Answers"
          %i[id body question_id created_at updated_at user_id best_answer_id].each do |attr|
            expect(page).to have_content(answer.send(attr))
          end
        when "Comments"
          %i[id body created_at updated_at user_id commentable_type commentable_id].each do |attr|
            expect(page).to have_content(comment.send(attr))
          end
        when "Users"
          %i[id email created_at updated_at].each do |attr|
            expect(page).to have_content(user.send(attr))
          end
        when "All"
          %i[id title body created_at updated_at user_id].each do |attr|
            expect(page).to have_content(question.send(attr))
          end

          %i[id body question_id created_at updated_at user_id best_answer_id].each do |attr|
            expect(page).to have_content(answer.send(attr))
          end

          %i[id body created_at updated_at user_id commentable_type commentable_id].each do |attr|
            expect(page).to have_content(comment.send(attr))
          end

          %i[id email created_at updated_at].each do |attr|
            expect(page).to have_content(user.send(attr))
          end
        end
      end
    end
  end
end