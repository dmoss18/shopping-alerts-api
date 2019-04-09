class CreateProductAlerts < ActiveRecord::Migration[5.2]
  def change
    create_table :product_alerts do |t|
      t.references :product, required: true
      t.references :user, required: true
      t.string :status, required: true, default: ProductAlert::Status::ACTIVE
      t.decimal :original_price
      t.decimal :quantifier, required: true
      t.string :quantifier_type, required: true
      t.datetime :sent_at

      t.timestamps
    end
  end
end
