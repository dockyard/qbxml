require 'spec_helper'

describe Qbxml::Hash do
  let(:qbxml) { Qbxml.new(:qb) }

  describe "self.remove_tags_preserve_content" do
    it "should remove all LineItems parent tags" do
      hash = { line_items: [ line_item(1), line_item(2) ] }
      hash = boilerplate('invoice', hash)
      xml = qbxml.to_qbxml(hash)
      expect(xml).to_not match /LineItems/
    end

    it "should remove all LineItems parent tags even with a tag called IncludeLineItems" do
      hash = { include_line_items: [ line_item(1), line_item(2) ] }
      hash = boilerplate('invoice', hash)
      xml = qbxml.to_qbxml(hash)
      expect(xml).to_not match /\<LineItems/
    end
  end

  def line_item(line_number)
    {
      invoice_line_add: {
        item_ref: {
          list_id: '3243'
        },
        desc: "Line #{line_number}",
        amount: 10.99,
        is_taxable: true,
        quantity: 3,
        rate_percent: 0,
        line_items: [{
          line: {
            desc: 'inside'
          }
        }]
      }
    }
  end

  def boilerplate(type, body_hash, options = {})
    {  :qbxml_msgs_rq =>
       [
         {
           :xml_attributes =>  { "onError" => "stopOnError"},
           "#{type}_rq".to_sym =>
           [
             {
               :xml_attributes => { "requestID" => "#{options[:id] || 1}" },
               "#{type}_#{options[:action] || 'add'}_rq".to_sym => body_hash
             }
           ]
         }
       ]
    }
  end
end
