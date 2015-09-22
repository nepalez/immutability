# encoding: utf-8
describe Immutability::Object do
  let(:object)      { described_class.new(instance) }

  let(:instance)    { double :instance,    version: 2, parent: parent      }
  let(:parent)      { double :parent,      version: 1, parent: grandparent }
  let(:grandparent) { double :grandparent, version: 0, parent: nil         }

  describe "#version" do
    subject { object.version }

    it "is delegated to instance" do
      expect(subject).to eql instance.version
    end
  end # describe #version

  describe "#each" do
    context "without block" do
      subject { object.each }

      it { is_expected.to be_kind_of Enumerator }
    end

    context "with a block" do
      subject { object.to_a }

      it "iterates via ancestors" do
        expect(subject).to eql [instance, parent, grandparent]
      end
    end
  end # describe #each

  describe "#at" do
    subject { object.at(point) }

    context "0" do
      let(:point) { 0 }

      it { is_expected.to eql grandparent }
    end

    context "positive number less than version" do
      let(:point) { "1" }

      it { is_expected.to eql parent }
    end

    context "positive number equal to version" do
      let(:point) { 2 }

      it { is_expected.to eql instance }
    end

    context "positive number greater than version" do
      let(:point) { 3 }

      it { is_expected.to be_nil }

      it "doesn't check #parent" do
        expect(instance).not_to receive(:parent)
        subject
      end
    end

    context "negative number less than version" do
      let(:point) { -1 }

      it { is_expected.to eql parent }
    end

    context "negative number equal to version" do
      let(:point) { -2 }

      it { is_expected.to eql grandparent }
    end

    context "negative number greater than version" do
      let(:point) { -3 }

      it { is_expected.to be_nil }

      it "doesn't check #parent" do
        expect(instance).not_to receive(:parent)
        subject
      end
    end
  end # describe #at

end # describe Immutability::Object
