class Video < ActiveRecord::Base
  belongs_to :category, dependent: :destroy

  validates_presence_of :title, :description
end