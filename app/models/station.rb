class Station < ActiveRecord::Base
  acts_as_taggable_on :tags, :affiliation, :color
  has_attached_file :home
  acts_as_commentable
  acts_as_rateable
end
