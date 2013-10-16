require 'uri'

class Params
  def initialize(req, route_params)
    @params = {}
    if req.query_string
      @params.merge!(parse_www_encoded_form(req.query_string))
      @params = @params.values[0]
    elsif req.body
      @params.merge!(parse_www_encoded_form(req.body))
    end
  end

  def [](key)
  end

  def to_s
    @params.to_s
  end

  private
  def parse_www_encoded_form(www_encoded_form)
    array = URI.decode_www_form(www_encoded_form)
    hash = {}
    inner_hash = {}
    array.each do |param|
      param_array = parse_key(param[0])
      param_array.each_with_index do |key, i|
        if (i + 1) == param_array.count
          inner_hash.merge!(Hash[key, param[1]])
          hash[param_array[i - 1]] = inner_hash
        end
      end
    end
    p hash
  end

  def parse_key(key)
    key.split(/\]\[|\[|\]/)
  end
end
