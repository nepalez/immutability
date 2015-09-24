# encoding: utf-8
describe Immutability::WithMemory do

  include_context :user
  before { User.send :include, described_class }

  let(:user) { User.new("Andrew", 44) { "admin" } }

  describe ".new" do
    subject { user }

    it "calls the initializer" do
      expect(subject.name).to eql "Andrew"
      expect(subject.age).to  eql 44
      expect(subject.role).to eql "admin"
    end

    it { is_expected.to be_immutable }

    it "doesn't add hidden variables" do
      expect(subject.instance_variables).to contain_exactly(
        :@name, :@age, :@role, :@version, :@parent
      )
    end
  end # describe .new

  describe "#methods" do
    subject { user.methods - Object.instance_methods }

    it "are expected" do
      expect(subject).to contain_exactly(
        :name, :age, :role, :version, :parent, :update, :forget_history, :at
      )
    end
  end # describe #methods

  describe "#version" do
    subject { user.version }

    it { is_expected.to eql 0 }
  end # describe #version

  describe "#parent" do
    subject { user.parent }

    it { is_expected.to be_nil }
  end # describe #parent

  describe "#update" do
    subject { user.update { @age = 45 } }

    it "creates new immutable instance" do
      expect(subject).to be_kind_of User
      expect(subject).to be_immutable
    end

    it "sets parent" do
      expect(subject.parent).to eql user
    end

    it "increments version" do
      expect(subject.version).to eql 1
      expect(subject.update.version).to eql 2
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
  end # describe #update

  describe "#forget_history" do
    subject { new_user.forget_history }

    let(:new_user) { user.update { @age = 45 } }

    it "creates new immutable instance" do
      expect(subject).to be_kind_of User
      expect(subject).to be_immutable
    end

    it "resets parent" do
      expect(subject.parent).to be_nil
    end

    it "resets version" do
      expect(subject.version).to eql 0
    end

    it "preserves other variables" do
      expect(subject.name).to eql new_user.name
      expect(subject.age).to  eql new_user.age
    end

    it "doesn't add hidden variables" do
      expect(subject.instance_variables).to eql new_user.instance_variables
    end
  end # describe #forget_history

  describe "#at" do
    subject { three.at(point) }

    let(:zero)  { user }
    let(:one)   { zero.update }
    let(:two)   { one.update }
    let(:three) { two.update }

    context "0" do
      let(:point) { 0 }

      it { is_expected.to eql zero }
    end

    context "positive number less than version" do
      let(:point) { 2 }

      it { is_expected.to eql two }
    end

    context "positive number greater than version" do
      let(:point) { 4 }

      it { is_expected.to be_nil }
    end

    context "negative number less than version" do
      let(:point) { -2 }

      it { is_expected.to eql one }
    end

    context "negative number greater than version" do
      let(:point) { -4 }

      it { is_expected.to be_nil }
    end
  end # describe #at

end # describe Immutability::WithMemory
