class Group < ApplicationRecord
  validates :title,presence:true
  validates :description,presence:true,length:{minimum:20}
  belongs_to :user
  has_many :users
  has_many :posts
  has_many :group_relationships
  has_many :members,through: :group_relationships,source: :user
end
