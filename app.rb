require 'sinatra'
require 'sinatra/namespace'
require 'oj'
require 'yaml'
require_relative './models/part'
require_relative './models/user'

require 'sinatra_swagger_ui_serve'

Oj.default_options = { mode: :compat }

set :views, File.expand_path('templates', __dir__)

before do
  content_type :json
end

#Register the swater file
SinatraSwaggerUiServe::Server.registered(spec_url: '/swagger.yaml')

# call swagger Server
use SinatraSwaggerUiServe::Server

#read the Swagger yaml file
get "/swagger.yaml" do
  content_type "application/x-yaml"
  File.read("swagger.yaml")
end

get '/view/part' do
  @parts = Part.all
  content_type :html, 'charset' => 'utf-8'
  erb :index
end



namespace '/api/v1' do

  # Create a new part
  post '/signup' do
    data = JSON.parse(request.body.read)
    part = User.create(
      username: data['username'],
      user_password: data['password'],
      role: data['role'],
    )
    status 201
    Oj.dump(part.values)
  end


  # Get all parts
  get '/parts' do
    parts = Part.all
    Oj.dump(parts.map(&:values))
  end

  # Get single part
  get '/parts/:id' do
    part = Part[params[:id]]
    halt 404, Oj.dump({ error: "Part not found" }) unless part
    Oj.dump(part.values)
  end

  # Create a new part
  post '/parts' do
    data = JSON.parse(request.body.read)
    part = Part.create(
      name: data['name'],
      description: data['description'],
      quantity: data['quantity'],
      price: data['price']
    )
    status 201
    Oj.dump(part.values)
  end

  # Update an existing part
  put '/parts/:id' do
    part = Part[params[:id]]
    halt 404, Oj.dump({ error: "Part not found" }) unless part

    data = JSON.parse(request.body.read)
    part.update(
      name: data['name'],
      description: data['description'],
      quantity: data['quantity'],
      price: data['price']
    )
    Oj.dump(part.values)
  end

  # Delete a part
  delete '/parts/:id' do
    part = Part[params[:id]]
    halt 404, Oj.dump({ error: "Part not found" }) unless part
    part.delete
    status 204
  end

end