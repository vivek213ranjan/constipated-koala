class CreatePayconiqTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :payconiq_transactions, :id => false  do |t|
      t.string :token, :unique => true, :limit => 64
      t.string :description

      t.decimal :amount, :scale => 2, :precision => 6
      t.string :status, :default => 'PENDING'
      t.belongs_to :member

      t.string :transaction_type
      t.string :transaction_id
      t.string :trxid
      t.string :qrurl
      t.string :deeplink
      
      t.timestamps
    end
    add_index :payconiq_transactions, :token, :unique => true
    add_index :payconiq_transactions, :trxid, :unique => true
  end
end
