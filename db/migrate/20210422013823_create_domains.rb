class CreateDomains < ActiveRecord::Migration[6.1]
  def change
    create_table :domains do |t|
      t.string :full_name
      t.references :person, null: false, foreign_key: true

      t.timestamps
    end
  end
end
