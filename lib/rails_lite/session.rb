require 'json'
require 'webrick'

class Session
  def initialize(req)
    found = false
    req.cookies.each do |cookie|
      if cookie.name == '_rails_lite_app'
        @cookie = JSON.parse(cookie.value)
        found = true
      end
    end

    unless found
      @cookie = {}
    end
  end

  def [](key)
    @cookie[key]
  end

  def []=(key, val)
    @cookie[key] = val
  end

  def store_session(res)
    res.cookies << WEBrick::Cookie.new('_rails_lite_app', @cookie.to_json)
  end
end
