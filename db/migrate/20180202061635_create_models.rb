class CreateModels < ActiveRecord::Migration[5.1]
  def change
    create_table :models do |t|
      t.string :message
      t.text :content

      t.timestamps
    end
  end
end
