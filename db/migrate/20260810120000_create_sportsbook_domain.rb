# frozen_string_literal: true

class CreateSportsbookDomain < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :uuid, null: false
      t.string :display_name, null: false
      t.string :email, null: false, default: ''
      t.string :encrypted_password, null: false, default: ''
      t.string :status, null: false, default: 'active'
      t.string :preferred_reveal_mode, null: false, default: 'honest'

      t.timestamps

      t.index :uuid, unique: true
      t.index :email, unique: true
    end

    create_table :wallets do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.string :currency, null: false, default: 'PLAY'
      t.bigint :balance_minor, null: false, default: 0
      t.integer :lock_version, null: false, default: 0

      t.timestamps
    end

    create_table :time_travel_sessions do |t|
      t.string :uuid, null: false
      t.references :user, null: false, foreign_key: true
      t.references :league, null: false, foreign_key: true
      t.date :travel_on, null: false
      t.string :round_fingerprint, null: false
      t.string :status, null: false, default: 'betting'
      t.string :reveal_mode, null: false, default: 'honest'
      t.datetime :reveal_started_at
      t.datetime :settled_at
      t.integer :lock_version, null: false, default: 0

      t.timestamps

      t.index :uuid, unique: true
      t.index %i[user_id round_fingerprint], unique: true, name: 'idx_time_sessions_user_round'
    end

    create_table :time_travel_session_matches do |t|
      t.string :uuid, null: false
      t.references :time_travel_session, null: false, foreign_key: true,
                                                index: { name: 'idx_session_matches_session' }
      t.references :source_match, null: false, foreign_key: { to_table: :matches },
                                  index: { name: 'idx_session_matches_source' }
      t.integer :position, null: false
      t.string :home_team, null: false
      t.string :away_team, null: false
      t.datetime :kickoff_at, null: false
      t.string :kickoff_timezone, null: false, default: 'Europe/London'
      t.decimal :home_odds, precision: 10, scale: 4, null: false
      t.decimal :draw_odds, precision: 10, scale: 4, null: false
      t.decimal :away_odds, precision: 10, scale: 4, null: false
      t.integer :final_home_score, null: false
      t.integer :final_away_score, null: false
      t.json :synthetic_events

      t.timestamps

      t.index :uuid, unique: true
      t.index %i[time_travel_session_id source_match_id], unique: true,
                                                           name: 'idx_session_matches_unique_source'
      t.index %i[time_travel_session_id position], unique: true,
                                                    name: 'idx_session_matches_unique_position'
    end

    create_table :wagers do |t|
      t.string :uuid, null: false
      t.references :user, null: false, foreign_key: true
      t.references :time_travel_session, null: false, foreign_key: true
      t.references :time_travel_session_match, null: false, foreign_key: true,
                                                      index: { name: 'idx_wagers_session_match' }
      t.references :source_match, null: false, foreign_key: { to_table: :matches }
      t.string :placement_key, null: false
      t.string :selection, null: false
      t.bigint :stake_minor, null: false
      t.decimal :decimal_odds, precision: 10, scale: 4, null: false
      t.bigint :potential_payout_minor, null: false
      t.bigint :payout_minor, null: false, default: 0
      t.string :status, null: false, default: 'pending'
      t.datetime :placed_at, null: false
      t.datetime :settled_at

      t.timestamps

      t.index :uuid, unique: true
      t.index %i[user_id source_match_id], unique: true, name: 'idx_wagers_one_per_fixture'
      t.index %i[user_id placement_key], name: 'idx_wagers_placement_key'
    end

    create_table :wallet_entries do |t|
      t.references :wallet, null: false, foreign_key: true
      t.references :wager, null: true, foreign_key: true
      t.string :entry_type, null: false
      t.bigint :amount_minor, null: false
      t.bigint :balance_after_minor, null: false
      t.string :idempotency_key, null: false
      t.json :metadata

      t.timestamps

      t.index :idempotency_key, unique: true
      t.index %i[wager_id entry_type], unique: true, name: 'idx_wallet_entries_wager_type'
    end
  end
end
