class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern = pattern
    @method = http_method
    @controller = controller_class
    @action = action_name
  end

  def matches?(req)
    method = req.request_method.downcase.to_sym
    path = req.path
    if method == @method && path =~ pattern
      true
    else false
    end
  end

  def run(req, res)
    p @pattern.match(req.path)
    controller = @controller.new(req, res)
    controller.invoke_action(@action)
  end
end

class Router
  attr_reader :routes

  def initialize
    @routes = []
  end

  def add_route(pattern, method, controller_class, action_name)
    @routes << Route.new(pattern, method, controller_class, action_name)
  end

  def draw(&proc)
    instance_eval(&proc)
  end

  [:get, :post, :put, :delete].each do |http_method|
    define_method(http_method) do |pattern, controller_class, action_name|
      add_route(pattern, http_method, controller_class, action_name)
    end
  end

  def match(req)
    p "ROUTES #{@routes}"
    @routes.each do |route|
      if route.matches?(req)
        return route
      end
    end
    nil
  end

  def run(req, res)
    route = match(req)
    if route.nil?
      p "404"
      res.status = 404
    else
      route.run(req, res)
    end
  end
end
