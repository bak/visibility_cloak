require "visibility_cloak/version"

class Module

  alias_method :private_without_block, :private

  def private_with_block(*args, &block)
    if block_given?
      methods = ->{ self.instance_methods(false) + self.private_instance_methods(false) }

      methods_pre = methods.call
      yield
      methods_post = methods.call
      new_methods = methods_post - methods_pre

      private_without_block *new_methods
    else
      private_without_block *args
    end
  end

  alias_method :private, :private_with_block

end

