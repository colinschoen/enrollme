# Data for a skill. Skills can be active or inactive
class Skill < ActiveRecord::Base
  # has_many :talents
  # has_many :users, through: :talents
  # has_and_belongs_to_many :users, through: :talents
  # belongs_to :talent
end
