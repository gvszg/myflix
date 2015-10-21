class Video < ActiveRecord::Base
  belongs_to :category, dependent: :destroy
end