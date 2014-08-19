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

    it "should have the default encoding of utf-8" do
      xml = qbxml.to_qbxml(boilerplate('customer', {}))
      expect(xml).to match /encoding=\"utf-8/
    end

    it "should be able to change the default encoding" do
      xml = qbxml.to_qbxml(boilerplate('customer', {}), to_xml_opts: { encoding: 'windows-1251' } )
      expect(xml).to match /encoding=\"windows-1251/
    end

    it "should just return the Nokogiri document" do
      xml = qbxml.to_qbxml(boilerplate('customer', {}), to_xml_opts: { doc: true } )
      expect(xml.class.to_s).to match /Nokogiri::XML::Document/
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

  def header(type, action)
    "#{type}_#{action}"
  end

  def boilerplate(type, body_hash, options = {})
    head = header(type, options[:action] || 'add')
    {  :qbxml_msgs_rq =>
       [
         {
           :xml_attributes =>  { "onError" => "stopOnError"},
           head + '_rq' =>
           [
             {
               :xml_attributes => { "requestID" => "#{options[:id] || 1}" },
               head => body_hash
             }
           ]
         }
       ]
    }
  end
end
