class CreateProducts < ActiveRecord::Migration[7.2]
  def change
    create_table :products do |t|
      t.string :name
      t.integer :category, null: false, default: 0
      t.integer :pricing_type, null: false, default: 0
      t.timestamps
    end
  end
end
