require './classes/discography'

bob_discography = DiscographyParser.read_discography_file("./discography.txt")
albums_sorted_by_decade = DiscographyParser.sort_albums_by_decade(bob_discography)

albums_sorted_by_decade.each do |decade, albums|
  puts "- List for decade: #{decade}"

  albums.each do |album|
    puts "-- Album: #{album[:title]} of year #{album[:year]}"
  end
end
