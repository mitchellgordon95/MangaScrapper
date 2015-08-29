require 'net/http'

# Config options
baseUrl = "http://www.mangareader.net/the-world-god-only-knows"
chapterStart = 1
chapterEnd = 268

for chapter in chapterStart..chapterEnd

    #Make a directory for each chapter
    Dir.mkdir "#{chapter}"

    page = 1
    while true do
        uri = URI("#{baseUrl}/#{chapter}/#{page}")
        res = Net::HTTP.get(uri)

        # If there are no more pages, continue to the next chapter
        break if res.include? "404 Not Found"

        imgUrlStart = res.index('id="img"')
        imgUrlStart = res.index('src="', imgUrlStart) + 5
        imgUrlEnd = res.index('"', imgUrlStart)
        imgUrlLen = imgUrlEnd - imgUrlStart

        imgUrl = res[imgUrlStart, imgUrlLen]

        imgUri = URI(imgUrl)

        file = File.new("#{chapter}/#{page}.jpg", "wb")

        imgData = Net::HTTP.get(imgUri)
        file.write(imgData)

        #Let the user know what's going on
        puts "Downloaded chapter #{chapter} page #{page}"

        page += 1
    end
end

