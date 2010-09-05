class Station < ActiveRecord::Base
  searchable do
    text :name, :boost => 1000, :stored => true
    text :call_letters, :boost => 10000, :stored => true
    float :frequency
    string :city, :stored => true
    string :state, :stored => true
    string :home_url, :stored => true
    float :average_rating
    time :created_at
    integer :cached_color
    string :tags, :multiple => true do
      tags.map { |x| x.name }
    end
    text :content do
      website.map { |x| x.content }.join('')
    end
    integer :status
  end
  default_scope :order => 'name, call_letters'
  acts_as_taggable_on :tags, :affiliation, :color
  #has_attached_file :home, :styles => { :thumb => ["100x100#", :png] }
  def home
    self.website.select { |x| x.category == 'home' }.first
  end
  acts_as_commentable
  acts_as_rateable
  has_many :website
  def published_at
    self.created_at
  end

  after_save :solr_index

  def solr_index
    Sunspot.index! self
  end
end
