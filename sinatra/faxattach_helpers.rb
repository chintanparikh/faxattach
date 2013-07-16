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
      code = match(txt)
      # For some reason, the OCR adds spaces which throws off the CoverPage detection
      code.delete(' ')
    end

    def match file
      regex = /^(ADN[\s|\S]*)$/
      File.open(file) do |line|
        match = line.match(regex)
        unless match.nil?
          return match[0]
        end
      end
    end
  end
end
