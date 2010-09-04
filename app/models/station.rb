class Station < ActiveRecord::Base
  default_scope :order => 'name, call_letters'
  acts_as_taggable_on :tags, :affiliation, :color
  #has_attached_file :home, :styles => { :thumb => ["100x100#", :png] }
  def home
    self.website.select { |x| x.category == 'home' }.first
  end
  acts_as_commentable
  acts_as_rateable
  has_many :website
end
