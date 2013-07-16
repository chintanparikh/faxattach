require 'sinatra'
require 'docsplit'
require 'json'
require './sinatra/faxattach_helpers'

class FaxAttach < Sinatra::Base
  helpers Sinatra::FaxAttachHelpers

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
    begin
      file = download path, 'attachments/'
    rescue
      status 404
    end

    code = extractCode file, 'attachments/'
    
    notifyAidin local, code
    status 200
  end
end

