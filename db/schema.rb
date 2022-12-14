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

ActiveRecord::Schema.define(version: 20171012005015) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.bigint "contact_id"
    t.integer "score"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_id"], name: "index_answers_on_contact_id"
  end

  create_table "campaigns", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name"
    t.string "sender_name"
    t.string "sender_email"
    t.string "logo"
    t.string "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "tmp_topics", default: [], array: true
    t.datetime "last_sent"
    t.integer "new_answers", default: 0
    t.integer "surveys_counter", default: 0
    t.integer "total_answers", default: 0
    t.index ["user_id"], name: "index_campaigns_on_user_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.bigint "campaign_id"
    t.string "name"
    t.string "email"
    t.datetime "sent_date"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "blacklist"
    t.jsonb "topics", default: {}, null: false
    t.boolean "valid_info", default: true, null: false
    t.index ["campaign_id"], name: "index_contacts_on_campaign_id"
    t.index ["email"], name: "index_contacts_on_email"
  end

  create_table "payments", force: :cascade do |t|
    t.string "full_name"
    t.string "phone"
    t.string "id_conekta"
    t.string "card_conekta"
    t.string "plan_name", default: "freelancer", null: false
    t.date "cycle_start"
    t.date "cycle_end"
    t.boolean "upgrade", default: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "records", force: :cascade do |t|
    t.integer "amount"
    t.string "status", default: "Pendiente"
    t.bigint "payment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["payment_id"], name: "index_records_on_payment_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "type"
    t.string "provider"
    t.string "uid"
    t.string "omniauth_name"
    t.text "image"
    t.string "avatar"
    t.integer "available_emails", default: 250
    t.boolean "terms", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
