# encoding: utf-8
describe Immutability do

  include_context :user
  before { User.send :include, described_class }

  let(:user) { User.new(name, 44) { "admin" } }
  let(:name) { "Andrew" }

  describe "::with_memory" do
    subject { described_class.with_memory }

    it { is_expected.to eql Immutability::WithMemory }
  end # describe .with_memory

  describe ".new" do
    subject { user }

    it "calls the initializer" do
      expect(subject.name).to eql name
      expect(subject.age).to  eql 44
      expect(subject.role).to eql "admin"
    end

    it { is_expected.to be_immutable }
  end # describe .new

  describe "#methods" do
    subject { user.methods - Object.instance_methods }

    it { is_expected.to contain_exactly(:name, :age, :role, :update) }
  end # describe #methods

  describe "#update" do
    subject { user.update { @age = 45 } }

    it "creates new immutable instance" do
      expect(subject).to be_kind_of User
      expect(subject).to be_immutable
    end

    it "applies the block" do
      expect(subject.age).to eql 45
    end

    it "preserves other variables" do
      expect(subject.name).to eql user.name
    end

    it "doesn't add hidden variables" do
      expect(subject.instance_variables).to eql user.instance_variables
    end

    context "without block" do
      subject { user.update }

      it "creates new immutable instance" do
        expect(subject).not_to be_equal(user)
        expect(subject).to be_immutable
      end

      it "preservers all variables" do
        expect(subject.age).to eql user.age
        expect(subject.name).to eql user.name
      end
    end
  end # describe #update

end # describe Immutability
