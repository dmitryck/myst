module Myst
  class Interpreter
    NativeLib.method :list_each, TList do
      if block
        this.elements.each do |elem|
          NativeLib.call_func(self, block, [elem], nil)
        end
      end

      this
    end

    NativeLib.method :list_size, TList do
      this.elements.size.to_i64
    end

    NativeLib.method :list_splat, TList do
      this
    end

    NativeLib.method :list_eq, TList, other : MTValue do
      return false  unless other.is_a?(TList)
      return true   if this == other
      return false  if this.elements.size != other.elements.size

      this.elements.zip(other.elements).each do |a, b|
        return false unless NativeLib.call_func_by_name(self, a, "==", [b]).truthy?
      end

      true
    end

    NativeLib.method :list_not_eq, TList, other : MTValue do
      return true   unless other.is_a?(TList)
      return false  if this == other
      return true   if this.elements.size != other.elements.size

      this.elements.zip(other.elements).each do |a, b|
        return true if NativeLib.call_func_by_name(self, a, "==", [b]).truthy?
      end

      false
    end

    NativeLib.method :list_add, TList, other : TList do
      TList.new(this.elements + other.elements)
    end

    NativeLib.method :list_access, TList, index : Int64 do
      if element = this.elements[index]?
        element
      else
        TNil.new
      end
    end

    NativeLib.method :list_access_assign, TList, index : Int64, value : MTValue do
      this.ensure_capacity(index + 1)
      this.elements[index] = value
    end

    NativeLib.method :list_minus, TList, other : TList do
      TList.new(this.elements - other.elements)
    end

    NativeLib.method :list_proper_subset, TList, other : TList do
      return false  unless other.is_a?(TList)
      return false  if this == other

      if (this.elements - other.elements).empty?
        true
      else
        false
      end
    end

    NativeLib.method :list_subset, TList, other : TList do
      return false  unless other.is_a?(TList)

      if (this.elements - other.elements).empty?
        true
      else
        false
      end
    end

    NativeLib.method :list_push, TList do
      unless __args.size.zero?
        __args.each { |arg| this.elements.push(arg) }
      end
      this
    end

    NativeLib.method :list_pop, TList do
      if value = this.elements.pop?
        value
      else
        TNil.new
      end
    end

    NativeLib.method :list_unshift, TList do
      unless __args.size.zero?
        __args.reverse_each { |arg| this.elements.unshift(arg) }
      end
      this
    end

    NativeLib.method :list_shift, TList do
      if value = this.elements.shift?
        value
      else
        TNil.new
      end
    end

    def init_list
      list_type = __make_type("List", @kernel.scope)

      NativeLib.def_instance_method(list_type, :each,    :list_each)
      NativeLib.def_instance_method(list_type, :size,    :list_size)
      NativeLib.def_instance_method(list_type, :==,      :list_eq)
      NativeLib.def_instance_method(list_type, :!=,      :list_not_eq)
      NativeLib.def_instance_method(list_type, :+,       :list_add)
      NativeLib.def_instance_method(list_type, :*,       :list_splat)
      NativeLib.def_instance_method(list_type, :[],      :list_access)
      NativeLib.def_instance_method(list_type, :[]=,     :list_access_assign)
      NativeLib.def_instance_method(list_type, :-,       :list_minus)
      NativeLib.def_instance_method(list_type, :<,       :list_proper_subset)
      NativeLib.def_instance_method(list_type, :<=,      :list_subset)
      NativeLib.def_instance_method(list_type, :push,    :list_push)
      NativeLib.def_instance_method(list_type, :pop,     :list_pop)
      NativeLib.def_instance_method(list_type, :unshift, :list_unshift)
      NativeLib.def_instance_method(list_type, :shift,   :list_shift)

      list_type
    end
  end
end
