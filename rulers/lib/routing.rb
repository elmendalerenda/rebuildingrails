module Rulers
  class Application
    class UnknownControllerError < StandardError; end
    def get_controller_and_action(env)
      _, cont, action, after =
        env["PATH_INFO"].split('/', 4)
      cont = cont.capitalize # "People"
      cont += "Controller" # "PeopleController"
      [Object.const_get(cont), action]
    rescue NameError
      raise UnknownControllerError
    end
  end
end
