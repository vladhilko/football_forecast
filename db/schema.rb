# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_08_10_120000) do
  create_table "active_admin_comments", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "author_id"
    t.string "author_type"
    t.text "body"
    t.datetime "created_at", null: false
    t.string "namespace"
    t.bigint "resource_id"
    t.string "resource_type"
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "admin_users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "bets", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.decimal "bet_amount", precision: 10, scale: 2, null: false
    t.string "bet_type", null: false
    t.datetime "created_at", null: false
    t.bigint "match_id", null: false
    t.decimal "odds", precision: 10, scale: 2, null: false
    t.decimal "payout_amount", precision: 10, scale: 2, default: "0.0", null: false
    t.string "result"
    t.string "status", default: "pending", null: false
    t.string "team"
    t.datetime "updated_at", null: false
    t.index ["match_id"], name: "index_bets_on_match_id"
  end

  create_table "betting_odds", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.decimal "away_team_win", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.decimal "draw", precision: 10, scale: 2, null: false
    t.decimal "home_team_win", precision: 10, scale: 2, null: false
    t.bigint "match_id", null: false
    t.datetime "updated_at", null: false
    t.index ["match_id"], name: "index_betting_odds_on_match_id"
  end

  create_table "countries", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_countries_on_name", unique: true
  end

  create_table "data_migrations", primary_key: "version", id: :string, charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
  end

  create_table "flipper_features", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "key", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_flipper_features_on_key", unique: true
  end

  create_table "flipper_gates", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "feature_key", null: false
    t.string "key", null: false
    t.datetime "updated_at", null: false
    t.string "value"
    t.index ["feature_key", "key", "value"], name: "index_flipper_gates_on_feature_key_and_key_and_value", unique: true
  end

  create_table "leagues", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "country_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id", "name"], name: "index_leagues_on_country_id_and_name", unique: true
  end

  create_table "matches", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "away_team", null: false
    t.datetime "created_at", null: false
    t.date "date", null: false
    t.string "home_team", null: false
    t.string "score", null: false
    t.bigint "season_id", null: false
    t.time "time"
    t.datetime "updated_at", null: false
    t.index ["season_id", "home_team", "away_team", "date"], name: "index_matches_on_season_id_and_home_team_and_away_team_and_date", unique: true
  end

  create_table "seasons", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "completeness_status", default: "initial", null: false
    t.datetime "created_at", null: false
    t.bigint "league_id", null: false
    t.string "name", null: false
    t.datetime "populated_at"
    t.datetime "updated_at", null: false
    t.string "uuid", null: false
    t.index ["league_id", "name"], name: "index_seasons_on_league_id_and_name", unique: true
    t.index ["uuid"], name: "index_seasons_on_uuid", unique: true
  end

  create_table "temporary_data_entries", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.json "data"
    t.string "key", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_temporary_data_entries_on_key", unique: true
  end

  create_table "time_travel_session_matches", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.decimal "away_odds", precision: 10, scale: 4, null: false
    t.string "away_team", null: false
    t.datetime "created_at", null: false
    t.decimal "draw_odds", precision: 10, scale: 4, null: false
    t.integer "final_away_score", null: false
    t.integer "final_home_score", null: false
    t.decimal "home_odds", precision: 10, scale: 4, null: false
    t.string "home_team", null: false
    t.datetime "kickoff_at", null: false
    t.string "kickoff_timezone", default: "Europe/London", null: false
    t.integer "position", null: false
    t.bigint "source_match_id", null: false
    t.json "synthetic_events"
    t.bigint "time_travel_session_id", null: false
    t.datetime "updated_at", null: false
    t.string "uuid", null: false
    t.index ["source_match_id"], name: "idx_session_matches_source"
    t.index ["time_travel_session_id", "position"], name: "idx_session_matches_unique_position", unique: true
    t.index ["time_travel_session_id", "source_match_id"], name: "idx_session_matches_unique_source", unique: true
    t.index ["time_travel_session_id"], name: "idx_session_matches_session"
    t.index ["uuid"], name: "index_time_travel_session_matches_on_uuid", unique: true
  end

  create_table "time_travel_sessions", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "league_id", null: false
    t.integer "lock_version", default: 0, null: false
    t.string "reveal_mode", default: "honest", null: false
    t.datetime "reveal_started_at"
    t.string "round_fingerprint", null: false
    t.datetime "settled_at"
    t.string "status", default: "betting", null: false
    t.date "travel_on", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.string "uuid", null: false
    t.index ["league_id"], name: "index_time_travel_sessions_on_league_id"
    t.index ["user_id", "round_fingerprint"], name: "idx_time_sessions_user_round", unique: true
    t.index ["user_id"], name: "index_time_travel_sessions_on_user_id"
    t.index ["uuid"], name: "index_time_travel_sessions_on_uuid", unique: true
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "display_name", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "preferred_reveal_mode", default: "honest", null: false
    t.string "status", default: "active", null: false
    t.datetime "updated_at", null: false
    t.string "uuid", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["uuid"], name: "index_users_on_uuid", unique: true
  end

  create_table "wagers", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.decimal "decimal_odds", precision: 10, scale: 4, null: false
    t.bigint "payout_minor", default: 0, null: false
    t.datetime "placed_at", null: false
    t.string "placement_key", null: false
    t.bigint "potential_payout_minor", null: false
    t.string "selection", null: false
    t.datetime "settled_at"
    t.bigint "source_match_id", null: false
    t.bigint "stake_minor", null: false
    t.string "status", default: "pending", null: false
    t.bigint "time_travel_session_id", null: false
    t.bigint "time_travel_session_match_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.string "uuid", null: false
    t.index ["source_match_id"], name: "index_wagers_on_source_match_id"
    t.index ["time_travel_session_id"], name: "index_wagers_on_time_travel_session_id"
    t.index ["time_travel_session_match_id"], name: "idx_wagers_session_match"
    t.index ["user_id", "placement_key"], name: "idx_wagers_placement_key"
    t.index ["user_id", "source_match_id"], name: "idx_wagers_one_per_fixture", unique: true
    t.index ["user_id"], name: "index_wagers_on_user_id"
    t.index ["uuid"], name: "index_wagers_on_uuid", unique: true
  end

  create_table "wallet_entries", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "amount_minor", null: false
    t.bigint "balance_after_minor", null: false
    t.datetime "created_at", null: false
    t.string "entry_type", null: false
    t.string "idempotency_key", null: false
    t.json "metadata"
    t.datetime "updated_at", null: false
    t.bigint "wager_id"
    t.bigint "wallet_id", null: false
    t.index ["idempotency_key"], name: "index_wallet_entries_on_idempotency_key", unique: true
    t.index ["wager_id", "entry_type"], name: "idx_wallet_entries_wager_type", unique: true
    t.index ["wager_id"], name: "index_wallet_entries_on_wager_id"
    t.index ["wallet_id"], name: "index_wallet_entries_on_wallet_id"
  end

  create_table "wallets", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "balance_minor", default: 0, null: false
    t.datetime "created_at", null: false
    t.string "currency", default: "PLAY", null: false
    t.integer "lock_version", default: 0, null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_wallets_on_user_id", unique: true
  end

  add_foreign_key "bets", "matches"
  add_foreign_key "betting_odds", "matches"
  add_foreign_key "leagues", "countries"
  add_foreign_key "matches", "seasons"
  add_foreign_key "seasons", "leagues"
  add_foreign_key "time_travel_session_matches", "matches", column: "source_match_id"
  add_foreign_key "time_travel_session_matches", "time_travel_sessions"
  add_foreign_key "time_travel_sessions", "leagues"
  add_foreign_key "time_travel_sessions", "users"
  add_foreign_key "wagers", "matches", column: "source_match_id"
  add_foreign_key "wagers", "time_travel_session_matches"
  add_foreign_key "wagers", "time_travel_sessions"
  add_foreign_key "wagers", "users"
  add_foreign_key "wallet_entries", "wagers"
  add_foreign_key "wallet_entries", "wallets"
  add_foreign_key "wallets", "users"
end
