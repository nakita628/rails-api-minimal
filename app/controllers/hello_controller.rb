class HelloController < ActionController::API
  def show
    render json: { message: "Hello, World!" }
  end
end
