class CreatePaymentHistories < ActiveRecord::Migration[7.1]
  def change
    create_table :payment_histories do |t|
      t.references :user, null: false, foreign_key: true
      t.float :application_fee
      t.float :transfer_amount
      t.float :total_amount
      t.string :status
      t.string :payment_intent_id

      t.timestamps
    end
  end
end
