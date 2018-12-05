class CreateVotes < ActiveRecord::Migration[5.2]
  def change
    create_table :votes do |t|
      t.integer :score
      t.references :votable, polymorphic: true, index: true
      t.references :user, index: true
      t.timestamps
    end
  end
end
