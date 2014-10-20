class Issues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.integer :github_id
      t.integer :redmine_id
      t.timestamps
    end
  end
end
