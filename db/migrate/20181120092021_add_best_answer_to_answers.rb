class AddBestAnswerToAnswers < ActiveRecord::Migration[5.2]
  def change
    add_column :answers, :best_answer_id, :bigint, index: true
  end
end
