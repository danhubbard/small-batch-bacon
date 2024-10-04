class CreatePriceTiers < ActiveRecord::Migration[7.2]
  def change
    create_table :price_tiers do |t|
      t.references :product, null: false, foreign_key: true
      t.decimal :price, null: false, precision: 10, scale: 2
      t.decimal :weight, precision: 10, scale: 2
      t.timestamps
    end
  end
end
