require 'sinatra'
require 'docsplit'
require './sinatra/faxattach_helpers'

class FaxAttach < Sinatra::Base
  helpers Sinatra::FaxAttachHelpers

  get '/*' do
    "hello world"
    status 405
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
    begin
      debugger
      file = test_download path
    rescue
      status 404
    end

    debugger
    code = extractCode file
    code
    status 202
  end

end

