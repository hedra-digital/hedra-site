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

ActiveRecord::Schema.define(:version => 20130902204912) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "addresses", :force => true do |t|
    t.integer  "user_id"
    t.string   "address"
    t.string   "number"
    t.string   "complement"
    t.string   "district"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "zip_code"
    t.boolean  "default"
    t.string   "identifier"
  end

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "binding_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "books", :force => true do |t|
    t.string   "title"
    t.integer  "pages"
    t.string   "isbn"
    t.text     "description"
    t.float    "width"
    t.float    "height"
    t.float    "weight"
    t.date     "released_at"
    t.integer  "binding_type_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "slug"
    t.string   "cover"
    t.float    "price_print"
    t.float    "price_ebook"
    t.integer  "category_id"
    t.integer  "publisher_id"
  end

  add_index "books", ["binding_type_id"], :name => "index_books_on_binding_type_id"
  add_index "books", ["slug"], :name => "index_books_on_slug", :unique => true

  create_table "books_languages", :id => false, :force => true do |t|
    t.integer "book_id"
    t.integer "language_id"
  end

  add_index "books_languages", ["book_id", "language_id"], :name => "index_books_languages_on_book_id_and_language_id"

  create_table "books_tags", :id => false, :force => true do |t|
    t.integer "book_id"
    t.integer "tag_id"
  end

  add_index "books_tags", ["book_id", "tag_id"], :name => "index_books_tags_on_book_id_and_tag_id"

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "slug"
  end

  add_index "categories", ["slug"], :name => "index_categories_on_slug", :unique => true

  create_table "ckeditor_assets", :force => true do |t|
    t.string   "data_file_name",                  :null => false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    :limit => 30
    t.string   "type",              :limit => 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], :name => "idx_ckeditor_assetable"
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], :name => "idx_ckeditor_assetable_type"

  create_table "features", :force => true do |t|
    t.integer  "book_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.string   "feature_image"
    t.integer  "page_id"
    t.string   "external_site_url"
  end

  add_index "features", ["book_id"], :name => "index_features_on_book_id"

  create_table "languages", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "new_releases", :force => true do |t|
    t.integer  "book_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "new_releases", ["book_id"], :name => "index_new_releases_on_book_id"

  create_table "order_items", :force => true do |t|
    t.integer  "order_id"
    t.integer  "book_id"
    t.float    "price"
    t.integer  "quantity"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "order_items", ["book_id"], :name => "index_order_items_on_book_id"
  add_index "order_items", ["order_id"], :name => "index_order_items_on_order_id"

  create_table "orders", :force => true do |t|
    t.decimal  "item_total",           :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.decimal  "total",                :precision => 8, :scale => 2, :default => 0.0, :null => false
    t.integer  "state"
    t.datetime "completed_at"
    t.integer  "shipment_state"
    t.integer  "payment_state"
    t.string   "email"
    t.text     "special_instructions"
    t.integer  "user_id"
    t.integer  "address_id"
    t.integer  "book_id"
    t.datetime "created_at",                                                          :null => false
    t.datetime "updated_at",                                                          :null => false
  end

  create_table "pages", :force => true do |t|
    t.integer  "tag_id"
    t.text     "body"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "tag_image"
    t.string   "hero_image"
  end

  create_table "participations", :force => true do |t|
    t.integer "role_id"
    t.integer "book_id"
    t.integer "person_id"
  end

  add_index "participations", ["book_id"], :name => "index_participations_on_book_id"
  add_index "participations", ["person_id"], :name => "index_participations_on_person_id"
  add_index "participations", ["role_id"], :name => "index_participations_on_role_id"

  create_table "people", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.date     "published_at"
    t.integer  "book_id"
    t.integer  "author_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
    t.string   "slug"
  end

  add_index "posts", ["slug"], :name => "index_posts_on_slug", :unique => true

  create_table "publishers", :force => true do |t|
    t.string   "name"
    t.string   "url"
    t.string   "logo"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.text     "about"
    t.text     "distributors"
    t.string   "contact_email"
    t.string   "contact"
  end

  create_table "recommendations", :force => true do |t|
    t.integer  "book_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "recommendations", ["book_id"], :name => "index_recommendations_on_book_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "slug"
  end

  add_index "tags", ["slug"], :name => "index_tags_on_slug", :unique => true

  create_table "transactions", :force => true do |t|
    t.integer  "user_id"
    t.integer  "order_id"
    t.string   "user_ip"
    t.string   "paypal_token"
    t.string   "paypal_payer_id"
    t.boolean  "completed"
    t.string   "paypal_transaction_id"
    t.date     "paypal_payment_date"
    t.float    "paypal_fee_amount"
    t.string   "paypal_pending_reason"
    t.string   "paypal_reason_code"
    t.integer  "status"
    t.datetime "created_at",            :null => false
    t.datetime "updated_at",            :null => false
    t.string   "customer_ip"
  end

  add_index "transactions", ["order_id"], :name => "index_transactions_on_order_id"
  add_index "transactions", ["user_id"], :name => "index_transactions_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "username"
    t.string   "name"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
