class CreateSubscribes < ActiveRecord::Migration[5.2]
  def change
    create_table :subscribes do |t|
      t.references :subscribable, polymorphic: true, index: true
      t.references :user, index: true
      t.timestamps
    end
  end
end
