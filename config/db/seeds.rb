# Sample data

return unless Hanami.env == :development

rom = Main::Slice["db.rom"]
cafes = rom.relations["cafes"]

cafes.insert(
  name: "Atlas",
  name_dmetaphone: "ATLS",
  address: "33 Hibberson St, Gungahlin ACT 2912, Australia",
  lat: -35.18531000,
  lng: 149.13362100,
  rating: 9,
  reviews_count: 1,
  created_at: Time.now
)
