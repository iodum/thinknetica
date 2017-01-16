class CreateSubscriptions < ActiveRecord::Migration[5.0]
  def change
    create_table :subscriptions do |t|
      t.references :user, foreign_key: true, index: true
      t.references :question, foreign_key: true, index: true

      t.timestamps
    end

    add_index :subscriptions, [:user_id, :question_id], unique: true
  end
end
