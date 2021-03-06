# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_06_08_084438) do

  create_table "abuse_reports", force: :cascade do |t|
    t.string "abuseable_type"
    t.bigint "abuseable_id"
    t.bigint "user_id", null: false
    t.text "details"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["abuseable_type", "abuseable_id"], name: "index_abuse_reports_on_abuseable_type_and_abuseable_id"
    t.index ["user_id"], name: "index_abuse_reports_on_user_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "answers", force: :cascade do |t|
    t.text "body"
    t.bigint "user_id", null: false
    t.bigint "question_id", null: false
    t.integer "reaction_count", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "popularity_credits_granted", default: false
    t.boolean "published", default: true
    t.boolean "marked_abused", default: false
    t.index ["question_id"], name: "index_answers_on_question_id"
    t.index ["user_id"], name: "index_answers_on_user_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text "body"
    t.string "commentable_type", null: false
    t.bigint "commentable_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id", null: false
    t.bigint "question_id", null: false
    t.integer "reaction_count", default: 0
    t.boolean "published", default: true
    t.boolean "marked_abused", default: false
    t.index ["commentable_type", "commentable_id"], name: "index_comments_on_commentable_type_and_commentable_id"
    t.index ["question_id"], name: "index_comments_on_question_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "credit_packs", force: :cascade do |t|
    t.string "name"
    t.integer "price"
    t.integer "credits"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "disabled", default: false
  end

  create_table "credit_transactions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "amount"
    t.integer "transaction_type"
    t.integer "credit_balance"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "transactable_type"
    t.bigint "transactable_id"
    t.index ["transactable_type", "transactable_id"], name: "transactable_index"
    t.index ["user_id"], name: "index_credit_transactions_on_user_id"
  end

  create_table "feed_activities", force: :cascade do |t|
    t.string "ip"
    t.string "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.boolean "viewed", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "notificable_type"
    t.bigint "notificable_id"
    t.index ["notificable_type", "notificable_id"], name: "index_notifications_on_notificable_type_and_notificable_id"
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "payment_transactions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "credit_pack_id", null: false
    t.integer "status"
    t.string "card_token"
    t.json "response"
    t.boolean "paid", default: false
    t.integer "price"
    t.integer "credits"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "paid_at"
    t.datetime "refunded_at"
    t.string "transaction_id"
    t.bigint "payment_transaction_id"
    t.bigint "credit_transaction_id"
    t.string "message"
    t.index ["credit_pack_id"], name: "index_payment_transactions_on_credit_pack_id"
    t.index ["credit_transaction_id"], name: "index_payment_transactions_on_credit_transaction_id"
    t.index ["payment_transaction_id"], name: "index_payment_transactions_on_payment_transaction_id"
    t.index ["user_id"], name: "index_payment_transactions_on_user_id"
  end

  create_table "question_topics", force: :cascade do |t|
    t.bigint "question_id", null: false
    t.bigint "topic_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["question_id"], name: "index_question_topics_on_question_id"
    t.index ["topic_id"], name: "index_question_topics_on_topic_id"
  end

  create_table "questions", force: :cascade do |t|
    t.bigint "user_id"
    t.string "title"
    t.text "content"
    t.string "url_slug"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "status"
    t.integer "reaction_count", default: 0
    t.timestamp "published_at"
    t.boolean "marked_abused", default: false
    t.index ["url_slug"], name: "index_questions_on_url_slug", unique: true
    t.index ["user_id"], name: "index_questions_on_user_id"
  end

  create_table "reactions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "reaction_type"
    t.string "reactable_type"
    t.bigint "reactable_id"
    t.index ["reactable_type", "reactable_id"], name: "index_reactions_on_reactable_type_and_reactable_id"
    t.index ["user_id"], name: "index_reactions_on_user_id"
  end

  create_table "topics", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_topics_on_name", unique: true
  end

  create_table "user_follows", force: :cascade do |t|
    t.integer "follower_id"
    t.integer "followed_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["followed_id"], name: "index_user_follows_on_followed_id"
    t.index ["follower_id", "followed_id"], name: "index_user_follows_on_follower_id_and_followed_id", unique: true
    t.index ["follower_id"], name: "index_user_follows_on_follower_id"
  end

  create_table "user_topics", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "topic_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["topic_id"], name: "index_user_topics_on_topic_id"
    t.index ["user_id"], name: "index_user_topics_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "password_digest"
    t.string "email"
    t.integer "user_type", default: 0
    t.integer "credit_balance", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "verified_at"
    t.string "confirmation_token"
    t.string "password_reset_token"
    t.datetime "password_token_expire_at"
    t.string "auth_token"
    t.string "stripe_id"
    t.boolean "disabled", default: false
    t.index ["auth_token"], name: "index_users_on_auth_token", unique: true
    t.index ["email", "confirmation_token"], name: "index_users_on_email_and_confirmation_token", unique: true
    t.index ["password_reset_token"], name: "index_users_on_password_reset_token"
    t.index ["password_token_expire_at"], name: "index_users_on_password_token_expire_at"
    t.index ["user_type"], name: "index_users_on_user_type"
  end

  add_foreign_key "abuse_reports", "users"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "answers", "questions"
  add_foreign_key "answers", "users"
  add_foreign_key "comments", "questions"
  add_foreign_key "comments", "users"
  add_foreign_key "credit_transactions", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "payment_transactions", "credit_packs"
  add_foreign_key "payment_transactions", "users"
  add_foreign_key "question_topics", "questions"
  add_foreign_key "question_topics", "topics"
  add_foreign_key "reactions", "users"
  add_foreign_key "user_topics", "topics"
  add_foreign_key "user_topics", "users"
end
