class MyStaticTest

  def self.double_it(value)
    value * 100
  end

  @@my_class_var = MyStaticTest.double_it 100

end