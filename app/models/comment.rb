class Comment < ActiveRecord::Base
  belongs_to :code

  validates :name, presence: true
  validates :email, presence: true
  validates :body, presence: true
end
