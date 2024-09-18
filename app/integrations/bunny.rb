class Bunny
  attr_reader :client

  def initialize(library_id: nil, access_key: nil)
    library_id ||= Rails.application.credentials.bunny_library_id
    access_key ||= Rails.application.credentials.bunny_access_key

    @client = BunnyClient.new(library_id: library_id, access_key: access_key)
  end
  
  def sync(page: 1)
    loop do
      response = client.get("/videos?page=#{page}")
      response[:items].each { synchronize_video(_1) }
      next_page = response[:currentPage] * response[:itemsPerPage] < response[:totalItems]
      break unless next_page
      page += 1
    end
  end

  def synchronize_video(item)
    video = Video.where(guid: item[:guid]).first_or_initialize
    video.update(
      library_id: item[:videoLibraryId],
      title: item[:title],
      captions: item[:captions].any? { _1[:label] == "English" }
    )
  end
end