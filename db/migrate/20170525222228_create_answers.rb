class CreateAnswers < ActiveRecord::Migration[5.1]
  def change
    create_table :answers do |t|
      t.belongs_to :contact
      t.integer :score
      t.text :comment

      t.timestamps
    end
  end
end
