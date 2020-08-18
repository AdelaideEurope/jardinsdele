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

ActiveRecord::Schema.define(version: 2020_07_29_213222) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "activites", force: :cascade do |t|
    t.string "nom"
    t.string "duree"
    t.integer "planche_id", default: 76
    t.bigint "legume_id"
    t.bigint "assistant_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "date"
    t.time "heure_debut"
    t.time "heure_fin"
    t.string "maladie_ravageur"
    t.index ["assistant_id"], name: "index_activites_on_assistant_id"
    t.index ["legume_id"], name: "index_activites_on_legume_id"
    t.index ["planche_id"], name: "index_activites_on_planche_id"
  end

  create_table "assistants", force: :cascade do |t|
    t.string "nom"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "commentaires", force: :cascade do |t|
    t.string "titre"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "activite_id"
    t.bigint "vente_id"
    t.index ["activite_id"], name: "index_commentaires_on_activite_id"
    t.index ["vente_id"], name: "index_commentaires_on_vente_id"
  end

  create_table "encouragements", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "message"
    t.string "auteur"
  end

  create_table "familles_legumes", force: :cascade do |t|
    t.string "nom"
    t.string "couleur"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "legumes", force: :cascade do |t|
    t.string "nom"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "legume_css"
    t.string "slug"
    t.string "unite"
    t.decimal "prix_general"
    t.string "famille"
    t.decimal "previ_legume"
    t.decimal "nb_planche"
    t.bigint "familles_legume_id"
    t.index ["familles_legume_id"], name: "index_legumes_on_familles_legume_id"
    t.index ["slug"], name: "index_legumes_on_slug", unique: true
  end

  create_table "memos", force: :cascade do |t|
    t.text "description"
    t.datetime "date"
    t.string "categorie"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "done", default: false
  end

  create_table "panier_lignes", force: :cascade do |t|
    t.decimal "prixunitaireht"
    t.decimal "prixunitairettc"
    t.decimal "totalht"
    t.decimal "totalttc"
    t.bigint "panier_id"
    t.bigint "legume_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "quantite"
    t.string "unite"
    t.bigint "planche_id"
    t.index ["legume_id"], name: "index_panier_lignes_on_legume_id"
    t.index ["panier_id"], name: "index_panier_lignes_on_panier_id"
    t.index ["planche_id"], name: "index_panier_lignes_on_planche_id"
  end

  create_table "paniers", force: :cascade do |t|
    t.bigint "vente_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "prix_ht"
    t.decimal "prix_ttc"
    t.integer "quantite"
    t.decimal "prix_reel_ttc"
    t.boolean "valide", default: false
    t.boolean "engagement"
    t.index ["vente_id"], name: "index_paniers_on_vente_id"
  end

  create_table "planches", force: :cascade do |t|
    t.string "nom"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "jardin"
  end

  create_table "previsionnel_planches", force: :cascade do |t|
    t.bigint "legume_id"
    t.bigint "planche_id"
    t.decimal "total_previ"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "activite_id"
    t.index ["activite_id"], name: "index_previsionnel_planches_on_activite_id"
    t.index ["legume_id"], name: "index_previsionnel_planches_on_legume_id"
    t.index ["planche_id"], name: "index_previsionnel_planches_on_planche_id"
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "taggings_taggable_context_idx"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vente_lignes", force: :cascade do |t|
    t.bigint "vente_id"
    t.bigint "legume_id"
    t.decimal "prixunitaireht"
    t.decimal "prixunitairettc"
    t.decimal "totalht"
    t.decimal "totalttc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "planche_id"
    t.decimal "quantite"
    t.string "unite"
    t.index ["legume_id"], name: "index_vente_lignes_on_legume_id"
    t.index ["planche_id"], name: "index_vente_lignes_on_planche_id"
    t.index ["vente_id"], name: "index_vente_lignes_on_vente_id"
  end

  create_table "vente_points", force: :cascade do |t|
    t.string "nom"
    t.string "categorie"
    t.string "adresse"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "total_ht", default: "0.0"
    t.decimal "total_ttc", default: "0.0"
    t.integer "code_postal"
    t.string "ville"
  end

  create_table "ventes", force: :cascade do |t|
    t.datetime "date"
    t.bigint "vente_point_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "total_ht", default: "0.0"
    t.decimal "total_ttc", default: "0.0"
    t.decimal "montant_regle", default: "0.0"
    t.decimal "montant_arrondi"
    t.datetime "date_facture"
    t.integer "num_facture"
    t.index ["vente_point_id"], name: "index_ventes_on_vente_point_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "activites", "assistants"
  add_foreign_key "activites", "legumes"
  add_foreign_key "activites", "planches", column: "planche_id"
  add_foreign_key "commentaires", "activites"
  add_foreign_key "commentaires", "ventes"
  add_foreign_key "legumes", "familles_legumes"
  add_foreign_key "panier_lignes", "legumes"
  add_foreign_key "panier_lignes", "paniers"
  add_foreign_key "panier_lignes", "planches", column: "planche_id"
  add_foreign_key "paniers", "ventes"
  add_foreign_key "previsionnel_planches", "activites"
  add_foreign_key "previsionnel_planches", "legumes"
  add_foreign_key "previsionnel_planches", "planches", column: "planche_id"
  add_foreign_key "taggings", "tags"
  add_foreign_key "vente_lignes", "legumes"
  add_foreign_key "vente_lignes", "planches", column: "planche_id"
  add_foreign_key "vente_lignes", "ventes"
  add_foreign_key "ventes", "vente_points"
end
