# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100912200450) do

  create_table "comments", :force => true do |t|
    t.string   "title",            :limit => 50, :default => ""
    t.text     "comment"
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pages", :force => true do |t|
    t.string   "url"
    t.string   "title"
    t.text     "body"
    t.text     "links"
    t.text     "headers"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ratings", :force => true do |t|
    t.integer  "rateable_id"
    t.string   "rateable_type"
    t.float    "average_rating"
    t.integer  "ratings_count"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "states", :force => true do |t|
    t.string   "name"
    t.string   "abbreviation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "stations", :force => true do |t|
    t.string   "name"
    t.string   "call_letters"
    t.string   "frequency"
    t.string   "website"
    t.string   "city"
    t.string   "state"
    t.float    "lat"
    t.float    "long"
    t.boolean  "radio"
    t.boolean  "television"
    t.string   "home_file_name"
    t.string   "home_content_type"
    t.string   "home_file_size"
    t.string   "home_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "cached_color"
    t.integer  "status"
    t.boolean  "primary"
    t.boolean  "published"
    t.string   "home_url"
  end

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "taggable_type"
    t.string   "context"
    t.datetime "created_at"
  end

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "transmitters", :force => true do |t|
    t.integer  "station_id"
    t.float    "lat"
    t.float    "long"
    t.text     "address"
    t.string   "frequency"
    t.string   "erp"
    t.string   "kind"
    t.string   "call_letters"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_ratings", :force => true do |t|
    t.integer  "rating_id"
    t.integer  "user_id"
    t.integer  "score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "encrypted_password", :limit => 128
    t.string   "salt",               :limit => 128
    t.string   "confirmation_token", :limit => 128
    t.string   "remember_token",     :limit => 128
    t.boolean  "email_confirmed",                   :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "websites", :force => true do |t|
    t.string   "url"
    t.string   "screenshot_file_name"
    t.string   "screenshot_content_type"
    t.string   "screenshot_file_size"
    t.string   "screenshot_updated_at"
    t.integer  "station_id"
    t.text     "content"
    t.integer  "color"
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
