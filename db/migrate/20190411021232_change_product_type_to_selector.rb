class ChangeProductTypeToSelector < ActiveRecord::Migration[5.2]
  def change
    rename_column :products, :product_type, :selector
  end
end
