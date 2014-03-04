class CreateModels < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.integer :team_id
      t.timestamps
    end
    create_table  :teams do |t|
      t.string :name
      t.timestamps
    end
    create_table  :tasks do |t|
      t.string :content
      t.integer :creator_id 
      t.integer :project_id 
      t.integer :assignee_id 
      t.datetime :end_date
      t.boolean :completed
      t.boolean :archived
      t.timestamps
    end

    add_column :users, :team_id, :string

  end
end
