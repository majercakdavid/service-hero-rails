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

ActiveRecord::Schema.define(version: 20170319125328) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string   "name"
    t.string   "street"
    t.string   "city"
    t.string   "ZIP"
    t.string   "state"
    t.string   "country"
    t.string   "phone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "administrators", force: :cascade do |t|
    t.string   "email"
    t.string   "password_digest"
    t.string   "name"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "business_business_owners", force: :cascade do |t|
    t.integer  "business_id"
    t.integer  "business_owner_id"
    t.datetime "date_from"
    t.datetime "date_to"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["business_id"], name: "index_business_business_owners_on_business_id", using: :btree
    t.index ["business_owner_id"], name: "index_business_business_owners_on_business_owner_id", using: :btree
  end

  create_table "business_owners", force: :cascade do |t|
    t.integer  "billing_address_id"
    t.integer  "shipping_address_id"
    t.string   "email"
    t.string   "password_digest"
    t.string   "name"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["billing_address_id"], name: "index_business_owners_on_billing_address_id", using: :btree
    t.index ["shipping_address_id"], name: "index_business_owners_on_shipping_address_id", using: :btree
  end

  create_table "business_service_orders", force: :cascade do |t|
    t.integer  "business_service_id"
    t.integer  "order_id"
    t.string   "label"
    t.text     "description"
    t.datetime "date_created"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["business_service_id"], name: "index_business_service_orders_on_business_service_id", using: :btree
    t.index ["order_id"], name: "index_business_service_orders_on_order_id", using: :btree
  end

  create_table "business_services", force: :cascade do |t|
    t.integer  "business_id"
    t.integer  "service_id"
    t.decimal  "price"
    t.datetime "date_added"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["business_id"], name: "index_business_services_on_business_id", using: :btree
    t.index ["service_id"], name: "index_business_services_on_service_id", using: :btree
  end

  create_table "businesses", force: :cascade do |t|
    t.integer  "billing_address_id"
    t.integer  "shipping_address_id"
    t.integer  "administrator_id"
    t.string   "name"
    t.datetime "date_joined"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["administrator_id"], name: "index_businesses_on_administrator_id", using: :btree
    t.index ["billing_address_id"], name: "index_businesses_on_billing_address_id", using: :btree
    t.index ["shipping_address_id"], name: "index_businesses_on_shipping_address_id", using: :btree
  end

  create_table "customers", force: :cascade do |t|
    t.integer  "billing_address_id"
    t.integer  "shipping_address_id"
    t.string   "email"
    t.string   "password_digest"
    t.string   "name"
    t.datetime "date_joined"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["billing_address_id"], name: "index_customers_on_billing_address_id", using: :btree
    t.index ["shipping_address_id"], name: "index_customers_on_shipping_address_id", using: :btree
  end

  create_table "documents", force: :cascade do |t|
    t.string   "documentable_type"
    t.integer  "documentable_id"
    t.string   "label"
    t.binary   "data"
    t.text     "dataurl"
    t.text     "description"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.index ["documentable_id", "documentable_type"], name: "index_documents_on_documentable_id_and_documentable_type", using: :btree
    t.index ["documentable_type", "documentable_id"], name: "index_documents_on_documentable_type_and_documentable_id", using: :btree
  end

  create_table "employees", force: :cascade do |t|
    t.integer  "business_id"
    t.integer  "billing_address_id"
    t.integer  "shipping_address_id"
    t.string   "email"
    t.string   "password_digest"
    t.string   "name"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["billing_address_id"], name: "index_employees_on_billing_address_id", using: :btree
    t.index ["business_id"], name: "index_employees_on_business_id", using: :btree
    t.index ["shipping_address_id"], name: "index_employees_on_shipping_address_id", using: :btree
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "customer_id"
    t.datetime "date_created"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["customer_id"], name: "index_orders_on_customer_id", using: :btree
  end

  create_table "services", force: :cascade do |t|
    t.string   "label"
    t.text     "description"
    t.datetime "date_added"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_foreign_key "business_business_owners", "business_owners"
  add_foreign_key "business_business_owners", "businesses"
  add_foreign_key "business_owners", "addresses", column: "billing_address_id"
  add_foreign_key "business_owners", "addresses", column: "shipping_address_id"
  add_foreign_key "business_service_orders", "business_services"
  add_foreign_key "business_service_orders", "orders"
  add_foreign_key "business_services", "businesses"
  add_foreign_key "business_services", "services"
  add_foreign_key "businesses", "addresses", column: "billing_address_id"
  add_foreign_key "businesses", "addresses", column: "shipping_address_id"
  add_foreign_key "businesses", "administrators"
  add_foreign_key "customers", "addresses", column: "billing_address_id"
  add_foreign_key "customers", "addresses", column: "shipping_address_id"
  add_foreign_key "employees", "addresses", column: "billing_address_id"
  add_foreign_key "employees", "addresses", column: "shipping_address_id"
  add_foreign_key "employees", "businesses"
  add_foreign_key "orders", "customers"
end
