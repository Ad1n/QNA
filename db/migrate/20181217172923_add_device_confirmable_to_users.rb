class AddDeviceConfirmableToUsers < ActiveRecord::Migration[5.2]
  def self.up
    change_table :users do |t|
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email
    end

    add_index :users, :confirmation_token, unique: true

  end

  def self.down
    remove_columns(:confirmation_token, :confirmed_at, :confirmation_sent_at, :unconfirmed_email)
    remove_index(:users, :confirmation_token)
  end
end
