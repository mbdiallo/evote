class Vote < ActiveRecord::Base
  mount_uploader :image, ImageUploader
end
