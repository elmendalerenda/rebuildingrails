class Object
  class MissingController < StandardError; end

  def self.const_missing(c)
    require Rulers.to_underscore(c.to_s)
    raise  MissingController if !c.match(/Controller$/).nil? && !Module.constants.include?(c)
    Object.const_get(c)
  end
end
