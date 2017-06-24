class Group < ApplicationRecord
  validates :title,presence:true
  validates :description,presence:true,length:{minimum:20}
  belongs_to :user
end
