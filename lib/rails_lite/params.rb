require 'uri'

class Params
  def initialize(req, route_params)
    @params = {}
    if req.query_string
      @params.merge!(parse_www_encoded_form(req.query_string))
    end
    @params.merge!(parse_www_encoded_form(req.body))
  end

  def [](key)
  end

  def to_s
    @params.to_s
  end

  private
  def parse_www_encoded_form(www_encoded_form)
    array = URI.decode_www_form(www_encoded_form)
    p array
    Hash[array]
  end

  def parse_key(key)
  end
end
