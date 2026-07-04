# Sample data

main = Main::Slice

account_statuses_table = main["db.gateway"].connection[:account_statuses]
unless account_statuses_table.to_a.any?
  account_statuses_table.multi_insert(
    [
      {id: 1, name: "Unverified"},
      {id: 2, name: "Verified"},
      {id: 3, name: "Closed"}
    ]
  )
end

return unless Hanami.env == :development

cafe_id = main["relations.cafes"].insert(
  name: "Atlas",
  name_dmetaphone: "ATLS",
  address: "33 Hibberson St, Gungahlin ACT 2912, Australia",
  lat: -35.18531000,
  lng: 149.13362100,
  created_at: Time.now
)

user_id = main["relations.users"].insert(
  name: "Sample Drinker",
  created_at: Time.now
)

main["relations.reviews"].insert(
  user_id: user_id,
  cafe_id: cafe_id,
  body: "Reliable oat flat white.",
  visited_on: Time.now.to_date,
  good_cup: true,
  created_at: Time.now
)

main["relations.likes"].insert(
  user_id: user_id,
  cafe_id: cafe_id,
  created_at: Time.now
)
