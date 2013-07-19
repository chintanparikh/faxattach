require 'sinatra'
require 'docsplit'
require 'json'
require './sinatra/faxattach_helpers'
require 'logger'

class FaxAttach < Sinatra::Base
  helpers Sinatra::FaxAttachHelpers

  configure do
    logger = Logger.new("#{settings.root}/log/#{settings.environment}.log")
  end

  get '/' do
    "Hello world"
  end
  
  put '/*' do
    status 405
  end

  patch '/*' do
    status 405
  end

  delete '/*' do
    status 405
  end

  options '/*' do
    status 405
  end

  link '/*' do
    status 405
  end

  unlink '/*' do
    status 405
  end

  post '/process' do
    path = params[:path]
    local = params[:local]
    logger.info path
    logger.info local
    
    # For development
    path.gsub!('https', 'http')
    
    logger.info path

    begin
      file = download path, 'attachments/'
      logger.info file
    rescue
      status 404
    end

    code = extractCode file, 'attachments/'
    logger.info code
    
    notifyAidin local, code
    status 200
  end
end

