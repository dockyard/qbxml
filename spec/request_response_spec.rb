require 'spec_helper'

describe Qbxml do
  context 'baseline spec' do
    let(:qb_new) { Qbxml.new(:qb) }

    context 'Responses' do
      it 'should convert without error' do
        responses.each do |data|
          expect {
            new_parse1 = qb_new.from_qbxml(data)
            new_parse2 =  qb_new.from_qbxml(qb_new.to_qbxml(new_parse1))
          }.to_not raise_error
        end
      end
    end

    context 'Requests' do
      it 'should convert without error' do
        requests.each do |data|
          expect {
            new_parse1 = qb_new.from_qbxml(data)
            new_parse2 =  qb_new.from_qbxml(qb_new.to_qbxml(new_parse1))
          }.to_not raise_error
        end
      end
        
    end
  end
end
