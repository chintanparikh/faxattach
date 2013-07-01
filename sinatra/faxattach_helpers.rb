require 'sinatra/base'
require 'open-uri'
require 'debugger'
require 'fileutils'
require 'net/http'
module Sinatra
  module FaxAttachHelpers
  
    def download path, out = ""
      FileUtils.mkdir_p out unless out.empty?
      local_path = out + 'attachment' + (Time.now.strftime("%Y%m%d%H%M%S")+(rand * 1000000).round.to_s) + ".pdf"
      File.open(local_path, 'wb+') do |file|
        file << open(path).read
      end
      local_path
    end

    def extractCode file_path, out = nil
      path = Docsplit.extract_text(file_path, clean: false, output: out)[0]
      txt = path.gsub('pdf', 'txt')
      code = nil
      File.open(txt).each do |line|
        # grabs the last non empty line and removes any additional characters
        code = line.chomp unless (line.chomp.empty? || line == "\f")
      end
      code
    end
  end
end
