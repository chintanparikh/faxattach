require 'sinatra/base'
require 'open-uri'
require 'debugger'
require 'net/http'
module Sinatra
  module FaxAttachHelpers
   # def download path
   #   local_file = 'attachment' + Time.now.strftime("%Y%m%d%H%M%S")+(rand * 1000000).to_i.to_s + '.pdf'
   #   File.open(local_file, 'wb+') do |file|
   #     file << open(path).read
   #   end
   #   debugger
   #   local_file
   # end

    def download path
      local_file = File.new 'attachment' + (Time.now.strftime("%Y%m%d%H%M%S")+(rand * 1000000).round.to_s) + ".pdf", 'wb+'
      uri = URI.parse(path)
      http_object = Net::HTTP.new(uri.host, uri.port)
      http_object.use_ssl = true if uri.scheme == 'https'
      request = Net::HTTP::Get.new uri.request_uri
      http_object.start do |http|
        response = http.request request
        debugger
        local_file.write(response.read_body)
      end
      debugger
      local_file.rewind
      local_file
    end

    def extractCode file_path
      path = Docsplit.extract_text file_path, clean: false, output: nil
      debugger
    end
  end
end
def test_download path
  local_path = 'attachment' + (Time.now.strftime("%Y%m%d%H%M%S")+(rand * 1000000).round.to_s) + ".pdf"
  File.open(local_path, 'wb+') do |file|
    file << open(path).read
  end
  local_path
end
