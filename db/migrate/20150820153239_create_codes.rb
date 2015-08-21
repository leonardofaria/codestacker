class CreateCodes < ActiveRecord::Migration
  def change
    create_table :codes do |t|
      t.string :title
      t.text :code
      t.string :description
      t.references :language, index: true, foreign_key: true
      t.boolean :privated

      t.timestamps null: false
    end
  end
end
