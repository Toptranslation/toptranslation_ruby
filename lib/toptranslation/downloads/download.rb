module Toptranslation
  class Download
    attr_reader :file

    def initialize(url, filename, options={})
      @file = store_file(request(url), filename)
    end

    private

    def store_file(response, filename)
      @file = Tempfile.new(filename)
      @file.binmode
      @file.write response
      @file.close

      @file
    end

    def request(download_url)
      DocumentStoreRequest.get(download_url)
    end
  end
end
