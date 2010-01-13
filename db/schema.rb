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

ActiveRecord::Schema.define(:version => 20100111131445) do

  create_table "candidate_members", :force => true do |t|
    t.integer  "candidate_id"
    t.integer  "member_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "candidates", :force => true do |t|
    t.string   "state_code"
    t.string   "state"
    t.string   "constituency"
    t.string   "name"
    t.string   "sex"
    t.string   "address_line_1"
    t.string   "address_line_2"
    t.string   "city_town_village"
    t.string   "age"
    t.string   "category"
    t.string   "party"
    t.string   "symbol_no"
    t.integer  "postal_votes"
    t.integer  "evm_votes"
    t.integer  "total_votes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "salutation"
  end

  create_table "members", :force => true do |t|
    t.text     "source"
    t.string   "birth_place"
    t.string   "email"
    t.text     "countries_visited"
    t.string   "mothers_name"
    t.string   "party_name"
    t.string   "name"
    t.string   "present_address"
    t.integer  "no_of_daughters"
    t.integer  "no_of_sons"
    t.text     "profession"
    t.string   "party_code"
    t.text     "books_published"
    t.text     "other_information"
    t.text     "recreation_activities"
    t.text     "special_interests"
    t.string   "marital_status"
    t.date     "birth_date"
    t.date     "marriage_date"
    t.text     "permanent_address"
    t.text     "education"
    t.string   "fathers_name"
    t.string   "spouse_name"
    t.string   "constituency"
    t.string   "state"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "salutation"
  end

  create_table "positions", :force => true do |t|
    t.string   "title"
    t.string   "span"
    t.integer  "member_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
