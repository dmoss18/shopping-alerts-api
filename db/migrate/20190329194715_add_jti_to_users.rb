class AddJtiToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :jti, :string
    add_index :users, :jti, unique: true

    add_index :users, :username, unique: true

    change_column_null :product_alerts, :product_id, false
    change_column_null :product_alerts, :user_id, false
    change_column_null :product_alerts, :quantifier, false
    change_column_null :product_alerts, :quantifier_type, false

    change_column_null :products, :vendor, false
    change_column_null :products, :url, false

    change_column_null :users, :email, false
    change_column_null :users, :username, false
  end
end
