# encoding: utf-8

shared_examples :user do
  before do
    class User
      attr_reader :name, :age, :role

      def initialize(name, age)
        @name = name
        @age  = age
        @role = block_given? ? yield : nil
      end
    end
  end

  after { Object.send :remove_const, :User }
end
