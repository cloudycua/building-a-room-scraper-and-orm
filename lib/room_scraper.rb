class RoomScraper

  def initialize(index_url)
    @index_url = index_url
    @doc = Nokogiri::HTML(open(index_url))
    binding.pry
  end

  def call
    rows.each do |row_doc|
      scrape_row(row_doc)
    end
  end

private
  def rows
    # <div class="content">
    #   <section class="resultinfo">_</section>
    #   <span class="rows">
    #      <p class="row" data-pid="6482775769" data-repost-of"4896745833">_</p>
    #      <p class="row" data-pid="5391871928" data-repost-of"4897061108">_</p>
    @rows ||= @doc.search("div.content span.rows p.row")
    # @doc.seach = @doc.css
    # ||=   or/equal operator, if the variable value already exists, keep the value, else assign the new value
  end

  def scrape_row(row)
    # scrape an individual row, take a row and return a hash
    {
      :date_created => row.search("time").attribute(datetime).text,
      :title => row.search("a.hdrlnk").text,
      :url => "#{@index_url}#{row.search("a.hdrlnk").attribute("href").text}",
      :price => row.search("span.price").text,
    }
  end

end
