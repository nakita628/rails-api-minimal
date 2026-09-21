ENV["RAILS_ENV"] ||= "test"

require_relative "../config/environment"
require "rspec/rails"

RSpec.configure do |config|
  config.openapi_root = Rails.root.join("swagger").to_s
  config.openapi_format = :yaml

  config.openapi_specs = {
    "v1/swagger.yaml" => {
      openapi: "3.0.1",
      info: { title: "rails-api-minimal API", version: "v1" },
      servers: [ { url: "http://localhost:3000" } ],
      paths: {},
      components: {
        schemas: {
          Hello: {
            type: :object,
            properties: { message: { type: :string, example: "Hello, World!" } },
            required: %w[message]
          }
        }
      }
    }
  }
end
