class DiscographyParser
  def self.read_discography_file(file_path)
    albums = []
    File.readlines(file_path).each do |line|
      album = self.split_year_and_title(line)
      albums << album
    end

    albums
  end

  def self.sort_albums_by_decade(albums)
    albums_by_decade = Hash.new { |hash, key| hash[key] = [] }

    albums.each do |album|
      decade = (album[:year] / 10) * 10
      albums_by_decade[decade] << album
    end

    albums_by_decade.each do |decade, albums|
      albums.sort_by! { |album| [album[:year], album[:title]] }
    end

    albums_by_decade
  end

  private

  def self.split_year_and_title(album_line)
    slices = album_line.split
    year = slices[0].to_i
    title = slices[1..-1].join(' ')

    return { year: year, title: title }
  end
end
