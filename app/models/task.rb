class Task < ActiveRecord::Base
  belongs_to :project
  belongs_to :user, :foreign_key => "assignee_id"
end
