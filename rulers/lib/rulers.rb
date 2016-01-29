require "rulers/version"
require "rulers/routing"
require "rulers/util"
require "rulers/controller"
require "rulers/dependencies"

module Rulers
  class Application
    def call(env)
      klass, act = get_controller_and_action(env)
      controller = klass.new(env)
      text = controller.send(act)
      [200, {'Content-Type' => 'text/html'},
       [text]]
     rescue UnknownControllerError
       index_content = File.readlines("public/index.html").join
       [200, {'Location' => 'index.html' }, [index_content]]
     end
  end
end
