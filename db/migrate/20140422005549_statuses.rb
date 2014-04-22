class Statuses < ActiveRecord::Migration
  def change
    create_table :statuses do |t|
      t.string :body, presence: true
      t.string :twitter_status_id, presence: true, uniq: true
      t.string :twitter_user_id, presence: true
      t.timestamps
    end


  end
end
