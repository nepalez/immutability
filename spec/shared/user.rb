# encoding: utf-8

shared_examples :user do
  before do
    class User
      attr_reader :name, :age

      def initialize(name, age)
        @name = name
        @age  = age
      end
    end
  end

  after { Object.send :remove_const, :User }
end
