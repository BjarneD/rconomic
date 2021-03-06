require './spec/spec_helper'

describe Economic::CreditorContactProxy do
  let(:session) { make_session }
  subject { Economic::CreditorContactProxy.new(session) }

  describe ".new" do
    it "stores session" do
      subject.session.should === session
    end
  end

  describe ".build" do
    it "instantiates a new CreditorContact" do
      subject.build.should be_instance_of(Economic::CreditorContact)
    end

    it "assigns the session to the CreditorContact" do
      subject.build.session.should === session
    end

    it "should not build a partial CreditorContact" do
      subject.build.should_not be_partial
    end

    context "when owner is a Creditor" do
      let(:creditor) { make_creditor(:session => session) }
      subject { creditor.contacts }

      it "should use the Creditors session" do
        subject.build.session.should == creditor.session
      end

      it "should initialize with values from Creditor" do
        contact = subject.build
        contact.creditor_handle.should == creditor.handle
      end
    end
  end

  describe ".find" do
    before :each do
      savon.stubs('CreditorContact_GetData').returns(:success)
    end

    it "gets contact data from API" do
      savon.expects('CreditorContact_GetData').with('entityHandle' => {'Id' => 42}).returns(:success)
      subject.find(42)
    end

    it "returns CreditorContact object" do
      subject.find(42).should be_instance_of(Economic::CreditorContact)
    end
  end
end
