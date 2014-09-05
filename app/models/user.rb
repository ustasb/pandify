class User < ActiveRecord::Base
  has_and_belongs_to_many :tracks

  validates :pandora_id, uniqueness: true
end
