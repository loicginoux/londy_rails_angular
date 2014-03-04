class Team < ActiveRecord::Base
  has_many :projects, :dependent => :destroy
  has_many :users, :dependent => :destroy
  
  def to_param
    "#{name}_{id}"
  end
end
