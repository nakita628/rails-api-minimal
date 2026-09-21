require "swagger_helper"

RSpec.describe "hello", type: :request do
  path "/hello" do
    get "Say hello" do
      tags "Hello"
      operationId "getHello"
      produces "application/json"

      response 200, "ok" do
        schema "$ref" => "#/components/schemas/Hello"

        run_test! do |response|
          expect(JSON.parse(response.body)).to eq("message" => "Hello, World!")
        end
      end
    end
  end
end
