# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120705190113) do

  create_table "cards", :force => true do |t|
    t.string   "suit"
    t.string   "value"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "card_owner_type"
    t.integer  "card_owner_id"
  end

  create_table "decks", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "game_id"
  end

  create_table "games", :force => true do |t|
    t.integer  "room_id"
    t.integer  "size"
    t.integer  "winner_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "played_tricks", :force => true do |t|
    t.integer  "size"
    t.integer  "user_id"
    t.integer  "trick_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "rooms", :force => true do |t|
    t.string   "name"
    t.integer  "size"
    t.string   "game_type"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "rounds", :force => true do |t|
    t.integer  "dealer_index"
    t.integer  "game_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "teams", :force => true do |t|
    t.integer  "bid",         :default => 0
    t.integer  "bags",        :default => 0
    t.integer  "round_score", :default => 0
    t.integer  "total_score", :default => 0
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "game_id"
  end

  create_table "tricks", :force => true do |t|
    t.integer  "leader_index"
    t.string   "lead_suit"
    t.integer  "round_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.integer  "total_score",      :default => 0
    t.integer  "round_score",      :default => 0
    t.integer  "bid",              :default => 0
    t.boolean  "going_nil",        :default => false
    t.boolean  "going_blind",      :default => false
    t.integer  "team_id"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.integer  "game_id"
    t.string   "crypted_password"
  end

end
