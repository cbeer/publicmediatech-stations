class Website < ActiveRecord::Base
  belongs_to :station
  acts_as_taggable_on :tags, :color_palette
  has_attached_file :screenshot, :styles => { :thumb => ["100x100#", :png], :gallery => ["480x360#", :png] }
  acts_as_commentable
  acts_as_rateable
end
