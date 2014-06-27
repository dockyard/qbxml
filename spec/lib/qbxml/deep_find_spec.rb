require 'spec_helper'

describe Qbxml do
  let(:qbxml) { Qbxml.new(:qb) }

  it "should be able to deep find a hash key" do
    xml = File.read(RESPONSE_DIR + '/customer_query_rs.xml') 
    hash = qbxml.from_qbxml(xml)
    hash.deep_find('statusMessage').should == "Status OK"
    hash.deep_find('list_id').should == "10006-1211236622"
  end
end
