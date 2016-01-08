class Comment < ActiveRecord::Base
  #name relation must singular
  belongs_to :article
end
