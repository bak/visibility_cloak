require 'minitest_helper'

class MethodBag
  protected do
    def block_protected_method_1() end
    def block_protected_method_2() end
  end

  private do
    def block_private_method_1() end
    def block_private_method_2() end
  end

  def standard_default_public_method() end

  private
  def scoped_private_method() end

  protected
  def scoped_protected_method_1() end

  public do
    def block_public_method_1() end
    def block_public_method_2() end
  end

  def scoped_protected_method_2() end

  def argument_private_method() end
  private :argument_private_method
end

describe Module do

  describe "private" do

    it "takes a block and sets the visibility of methods contained therein" do
      MethodBag.private_instance_methods(false).must_include :block_private_method_1
      MethodBag.private_instance_methods(false).must_include :block_private_method_2
    end

    it "does not affect the default visibility" do
      MethodBag.public_instance_methods(false).must_include :standard_default_public_method
    end

    # So far, this one is always failing. `private_without_block` doesn't seem to do 
    # the work of `private` with no args (but it does the work of `private` with args).
    #
    # With no args, `private` sets the scope to private (Ruby 2.0; 2.1 is essentially same but refactored):
    #
    #                static VALUE
    # rb_mod_private(int argc, VALUE *argv, VALUE module)
    # {
    #     secure_visibility(module); // checks if we *can* change method visibility
    #     if (argc == 0) {
    #         SCOPE_SET(NOEX_PRIVATE); // >:|
    #     }
    #     else {
    #         set_method_visibility(module, argc, argv, NOEX_PRIVATE);
    #     }
    #     return module;
    # }
    #
    # ... 
    #
    # #define SCOPE_SET(f)   (rb_vm_cref()->nd_visi = (f))
    it "without args, changes the visibility of subsequent method definitions" do
      MethodBag.private_instance_methods(false).must_include :scoped_private_method
    end

    it "takes an argument and sets the visibility of those method(s)" do
      MethodBag.private_instance_methods(false).must_include :argument_private_method
    end

  end
end

