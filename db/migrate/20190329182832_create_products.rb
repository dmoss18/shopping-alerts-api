class CreateProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
      t.string :vendor, required: true
      t.string :isbn
      t.string :vendor_identifier
      t.string :description
      t.string :url, required: true
      t.string :image_url
      t.string :product_type

      t.timestamps
    end

    add_index :products, :isbn
    add_index :products, :vendor_identifier
  end
end
