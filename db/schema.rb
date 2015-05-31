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

ActiveRecord::Schema.define(version: 20150531104624) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "advanced_payments", force: true do |t|
    t.integer  "home_id"
    t.datetime "start_date"
    t.integer  "duration"
    t.string   "code"
    t.text     "description"
    t.decimal  "amount",       precision: 14, scale: 2, default: 0.0
    t.boolean  "is_confirmed",                          default: false
    t.datetime "confirmed_at"
    t.boolean  "is_deleted",                            default: false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cash_bank_adjustments", force: true do |t|
    t.integer  "cash_bank_id"
    t.decimal  "amount",          precision: 14, scale: 2, default: 0.0
    t.integer  "status",                                   default: 1
    t.datetime "adjustment_date"
    t.datetime "confirmed_at"
    t.boolean  "is_confirmed",                             default: false
    t.datetime "deleted_at"
    t.boolean  "is_deleted",                               default: false
    t.text     "description"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cash_bank_mutations", force: true do |t|
    t.integer  "target_cash_bank_id"
    t.integer  "source_cash_bank_id"
    t.decimal  "amount",              precision: 14, scale: 2, default: 0.0
    t.datetime "mutation_date"
    t.boolean  "is_confirmed",                                 default: false
    t.text     "description"
    t.datetime "confirmed_at"
    t.datetime "deleted_at"
    t.boolean  "is_deleted",                                   default: false
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cash_banks", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "is_bank",                              default: true
    t.decimal  "amount",      precision: 14, scale: 2, default: 0.0
    t.datetime "deleted_at"
    t.boolean  "is_deleted",                           default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cash_mutations", force: true do |t|
    t.string   "source_class"
    t.integer  "source_id"
    t.string   "source_code"
    t.decimal  "amount",        precision: 14, scale: 2, default: 0.0
    t.integer  "status",                                 default: 1
    t.datetime "mutation_date"
    t.integer  "cash_bank_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "deposit_documents", force: true do |t|
    t.string   "code"
    t.text     "description"
    t.integer  "user_id"
    t.integer  "home_id"
    t.datetime "deposit_date"
    t.decimal  "amount_deposit", precision: 14, scale: 2, default: 0.0
    t.decimal  "amount_charge",  precision: 14, scale: 2, default: 0.0
    t.boolean  "is_confirmed",                            default: false
    t.datetime "confirmed_at"
    t.boolean  "is_finished",                             default: false
    t.datetime "finished_at"
    t.boolean  "is_deleted",                              default: false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "home_assignments", force: true do |t|
    t.integer  "user_id"
    t.integer  "home_id"
    t.boolean  "is_deleted",      default: false
    t.datetime "deleted_at"
    t.datetime "assignment_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "home_types", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.decimal  "amount",      precision: 14, scale: 2, default: 0.0
    t.datetime "deleted_at"
    t.boolean  "is_deleted",                           default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "homes", force: true do |t|
    t.string   "name"
    t.text     "address"
    t.integer  "home_type_id"
    t.datetime "deleted_at"
    t.boolean  "is_deleted",   default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoices", force: true do |t|
    t.integer  "source_id"
    t.string   "source_class"
    t.string   "source_code"
    t.string   "code"
    t.integer  "home_id"
    t.decimal  "amount",       precision: 14, scale: 2, default: 0.0
    t.datetime "due_date"
    t.datetime "invoice_date"
    t.text     "description"
    t.boolean  "is_confirmed",                          default: false
    t.datetime "confirmed_at"
    t.boolean  "is_deleted",                            default: false
    t.datetime "deleted_at"
    t.boolean  "is_paid",                               default: false
    t.datetime "paid_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "monthly_generators", force: true do |t|
    t.datetime "generated_date"
    t.string   "code"
    t.text     "description"
    t.boolean  "is_confirmed",   default: false
    t.datetime "confirmed_at"
    t.boolean  "is_deleted",     default: false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payables", force: true do |t|
    t.string   "source_class"
    t.integer  "source_id"
    t.string   "source_code"
    t.decimal  "amount",           precision: 14, scale: 2, default: 0.0
    t.decimal  "remaining_amount", precision: 14, scale: 2, default: 0.0
    t.boolean  "is_deleted",                                default: false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payment_requests", force: true do |t|
    t.integer  "vendor_id"
    t.datetime "request_date"
    t.string   "code"
    t.text     "description"
    t.decimal  "amount",       precision: 14, scale: 2, default: 0.0
    t.boolean  "is_confirmed",                          default: false
    t.datetime "confirmed_at"
    t.boolean  "is_deleted",                            default: false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payment_voucher_details", force: true do |t|
    t.integer  "payment_voucher_id"
    t.decimal  "amount",             precision: 14, scale: 2, default: 0.0
    t.integer  "payable_id"
    t.boolean  "is_deleted",                                  default: false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payment_vouchers", force: true do |t|
    t.string   "code"
    t.text     "description"
    t.integer  "vendor_id"
    t.integer  "cash_bank_id"
    t.datetime "payment_date"
    t.decimal  "amount",       precision: 14, scale: 2, default: 0.0
    t.boolean  "is_confirmed",                          default: false
    t.datetime "confirmed_at"
    t.boolean  "is_deleted",                            default: false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "receipt_vouchers", force: true do |t|
    t.string   "code"
    t.text     "description"
    t.integer  "user_id"
    t.integer  "receivable_id"
    t.integer  "cash_bank_id"
    t.datetime "receipt_date"
    t.decimal  "amount",        precision: 14, scale: 2, default: 0.0
    t.boolean  "is_confirmed",                           default: false
    t.datetime "confirmed_at"
    t.boolean  "is_deleted",                             default: false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "receivables", force: true do |t|
    t.string   "source_class"
    t.integer  "source_id"
    t.string   "source_code"
    t.decimal  "amount",           precision: 14, scale: 2, default: 0.0
    t.decimal  "remaining_amount", precision: 14, scale: 2, default: 0.0
    t.boolean  "is_deleted",                                default: false
    t.datetime "deleted_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", force: true do |t|
    t.string   "name",        null: false
    t.string   "title",       null: false
    t.text     "description", null: false
    t.json     "the_role",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "single_group_loan_weekly_collection_reports", force: true do |t|
    t.integer  "group_loan_weekly_collection_id"
    t.boolean  "is_finished",                     default: false
    t.datetime "finished_at"
    t.string   "return_url"
    t.string   "stored_result_url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "role_id"
    t.string   "name"
    t.string   "username"
    t.string   "login"
    t.boolean  "is_deleted",             default: false
    t.boolean  "is_main_user",           default: false
    t.string   "authentication_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "vendors", force: true do |t|
    t.string   "name"
    t.text     "address"
    t.text     "description"
    t.datetime "deleted_at"
    t.boolean  "is_deleted",  default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
