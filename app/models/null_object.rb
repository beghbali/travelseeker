class NullObject
  def !; true; end

  def method_missing(*args, &block)
    nil
  end
end