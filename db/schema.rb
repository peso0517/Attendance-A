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

ActiveRecord::Schema.define(version: 20190623142157) do

  create_table "attendances", force: :cascade do |t|
    t.datetime "attendance_time"
    t.datetime "leaving_time"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "day"
    t.string "business_process"
    t.datetime "overtime_plan"
    t.integer "apply_state", default: 1, null: false
    t.integer "authority_user_id"
    t.integer "check", default: 0, null: false
    t.boolean "change_flg", default: false
    t.string "remarks"
    t.integer "attendance_change_state", default: 1, null: false
    t.integer "edit_next_check", default: 0, null: false
    t.integer "edit_authority_user_id"
    t.datetime "edit_attendance_time"
    t.datetime "edit_leaving_time"
    t.datetime "before_edit_attendance_time"
    t.datetime "before_edit_leaving_time"
    t.date "latest_approval_date"
    t.index ["user_id"], name: "index_attendances_on_user_id"
  end

  create_table "bases", force: :cascade do |t|
    t.string "base_name"
    t.string "base_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "microposts", force: :cascade do |t|
    t.text "content"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "picture"
    t.index ["user_id", "created_at"], name: "index_microposts_on_user_id_and_created_at"
    t.index ["user_id"], name: "index_microposts_on_user_id"
  end

  create_table "one_month_attendances", force: :cascade do |t|
    t.integer "one_month_apply_state"
    t.date "one_month_apply_date"
    t.integer "one_month_authority_user_id"
    t.integer "one_month_applying_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "approval_flg", default: false
  end

  create_table "relationships", force: :cascade do |t|
    t.integer "follower_id"
    t.integer "followed_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["followed_id"], name: "index_relationships_on_followed_id"
    t.index ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true
    t.index ["follower_id"], name: "index_relationships_on_follower_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin", default: false
    t.string "activation_digest"
    t.boolean "activated", default: false
    t.datetime "activated_at"
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.string "affiliation"
    t.datetime "specified_work_time"
    t.datetime "basic_work_time"
    t.datetime "specified_end_time"
    t.string "user_card_id"
    t.integer "employee_number"
    t.boolean "superior", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
