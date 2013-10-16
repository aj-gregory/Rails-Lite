require 'erb'
require_relative 'params'
require_relative 'session'
require 'active_support/core_ext'

class ControllerBase
  attr_reader :params

  def initialize(req, res, *route_params)
    @req = req
    @res = res
  end

  def session
    @session ||= Session.new(@req)
  end

  def already_rendered?
  end

  def redirect_to(url)
    @res.set_redirect(WEBrick::HTTPStatus[302], url)
    @already_built_response = @res
    @session.store_session(@res)
  end

  def render_content(content, type)
    @res.content_type = type
    @res.body = content
    @already_built_response = @res
    @session.store_session(@res)
  end

  def render(template_name, type = 'text/text')
    f = "views/#{self.class.to_s.underscore}/#{template_name.to_s}.html.erb"
    p f
    erb_template = ERB.new(File.read(f))
    render_content(erb_template.result(binding), type)
  end

  def invoke_action(name)
  end
end
