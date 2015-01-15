# encoding: utf-8
require 'spec_helper'

describe Qbxml::Hash do
  let(:qbxml) { Qbxml.new(:qb) }

  describe 'self.hash_to_xml' do
    it 'should encode special characters with decimal htmlentities' do
      last_name = 'Hablé ">'
      c = customer
      c[:last_name] = last_name
      c[:bill_address][:addr2] = '123 Hölt Brewery Rd'
      xml = qbxml.to_qbxml(boilerplate('customer', c))
      puts xml
    end

    it 'should encode special characters with decimal htmlentities within line items' do
      desc = 'Hablé "boxes">'
      desc2 = 'Hölt Beer Bottles'
      l1 = line_item(1)
      l1[:invoice_line_add][:line_items].first[:line][:desc] = desc
      l2 = line_item(2)
      l2[:invoice_line_add][:line_items].first[:line][:desc] = desc2
      hash = { line_items: [ l1, l2 ] }
      hash = boilerplate('invoice', hash)
      xml = qbxml.to_qbxml(hash)
      #expect(xml).to_not match /LineItems/
      #xml = qbxml.to_qbxml(boilerplate('customer', c))
      #puts xml
    end
  end

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

  def customer
    {
      name: 'Miles Hastings',
      company_name: nil,
      first_name: 'Miles',
      last_name: 'Hastings',
      phone: '555-444-555',
      alt_phone: '',
      bill_address: {
          email: 'mh@mailx.com',
          addr1: 'Miles Hastings',
          addr2: '123 Main Str.',
          addr3: 'PO BOX 123',
          city: 'New Cannan',
          state: 'NH',
          postal_code: '13222',
          country: 'USA'
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
