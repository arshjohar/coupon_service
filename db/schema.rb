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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140324141707) do

  create_table "coupons", id: false, force: true do |t|
    t.string   "code",                                  null: false
    t.string   "referrer_customer_ref"
    t.string   "referred_customer_ref"
    t.integer  "shopping_credits_to_referrer_customer"
    t.integer  "shopping_credits_to_referred_customer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "coupons", ["code"], name: "index_coupons_on_code", unique: true, using: :btree

  create_table "customers", id: false, force: true do |t|
    t.string  "ref",                                null: false
    t.integer "total_shopping_credits", default: 0, null: false
  end

  add_index "customers", ["ref"], name: "index_customers_on_ref", unique: true, using: :btree

end
