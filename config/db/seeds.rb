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

main["relations.cafes"].insert(
  name: "Atlas",
  name_dmetaphone: "ATLS",
  address: "33 Hibberson St, Gungahlin ACT 2912, Australia",
  lat: -35.18531000,
  lng: 149.13362100,
  rating: 9,
  reviews_count: 1,
  created_at: Time.now
)
