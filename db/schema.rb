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

ActiveRecord::Schema.define(:version => 20120103014826) do

  create_table "node_links", :force => true do |t|
    t.integer  "node_id"
    t.integer  "linked_node_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "node_types", :force => true do |t|
    t.string   "name"
    t.string   "reachable_img"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nodes", :force => true do |t|
    t.string   "name"
    t.integer  "x"
    t.integer  "y"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "node_type_id"
    t.integer  "strength"
    t.boolean  "is_human"
  end

  create_table "players", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_human"
  end

  create_table "turn_logs", :force => true do |t|
    t.string   "desc"
    t.text     "notes"
    t.datetime "when"
    t.integer  "unit_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "unit_stats", :force => true do |t|
    t.string   "name"
    t.integer  "value"
    t.integer  "unit_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "units", :force => true do |t|
    t.string   "name"
    t.string   "map_img"
    t.integer  "node_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "player_id"
    t.integer  "node_link_id"
    t.integer  "red"
    t.integer  "blue"
    t.integer  "green"
  end

end
