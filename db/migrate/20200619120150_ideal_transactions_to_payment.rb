class IdealTransactionsToPayment < ActiveRecord::Migration[6.0]
  def up
    rename_table :ideal_transactions, :payments
    rename_column :payments, :redirect_uri, :ideal_redirect_uri

    remove_column :payments, :transaction_type, :string

    add_column :payments, :transaction_type, :integer, default: 0
    add_column :payments, :payment_type, :integer, default: 0

    change_column :checkout_transactions, :payment_method, :string, limit: 32
  end

  def down

    remove_column :payments,:payment_type
    remove_column :payments,:transaction_type

    add_column :payments, :transaction_type,:string
    rename_column :payments, :ideal_redirect_uri, :redirect_uri

    rename_table :payments, :ideal_transactions
    change_column :checkout_transactions, :payment_method, :string, limit:7
  end
end
