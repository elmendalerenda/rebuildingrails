require 'erubis'
require "rulers/file_model"

module Rulers
  class Controller
    include Rulers::Model

    def initialize(env)
      @env = env
      @routing_params = {}
    end

    def request
      @request ||= Rack::Request.new(@env)
    end

    def dispatch(action, routing_params = {})
      @routing_params = routing_params
      text = self.send(action)
      r = get_response
      if r
        [r.status, r.headers, [r.body].flatten]
      else
        [200, {'Content-Type' => 'text/html'},
         [text].flatten]
      end
    end

    def self.action(act, rp = {})
      proc { |e| self.new(e).dispatch(act, rp) }
    end

    def params
      request.params.merge @routing_params
    end

    def env
      @env
    end

    def response(text, status = 200, headers = {})
      raise "Already responded!" if @response
      a = [text].flatten
      @response = Rack::Response.new(a, status, headers)
    end

    def get_response  # Only for Rulers
      @response
    end

    def render_response(*args)
      response(render(*args))
    end

    def render(view_name, locals = {})
      filename = File.join "app", "views",
        "#{view_name}.html.erb"
      template = File.read filename
      eruby = Erubis::Eruby.new(template)
      eruby.result locals.merge(:env => env).merge(controller_vars)
    end

    def controller_vars
      self.instance_variables.each_with_object({}) do |v, acc|
        acc[v] = self.instance_variable_get(v)
      end
    end
  end
end
