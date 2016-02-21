require "rulers/version"
require "rulers/routing"
require "rulers/util"
require "rulers/controller"
require "rulers/dependencies"
require "rulers/file_model"

module Rulers
  class Application
    def call(env)
      rack_app = get_rack_app(env)
      rack_app.call(env)
    end

    def route(&block)
      @route_obj ||= RouteObject.new
      @route_obj.instance_eval(&block)
    end

    def get_rack_app(env)
      raise "No routes!" unless @route_obj
      @route_obj.check_url env["PATH_INFO"]
    end
  end
end
