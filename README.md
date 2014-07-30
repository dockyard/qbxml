# Qbxml

Qbxml is a QBXML parser and validation tool.

## Installation

Add this line to your application's Gemfile:

    gem 'qbxml'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install qbxml

## Usage

### Initialization

The parser can be initialized to either Quickbooks (:qb) or Quickbooks Point of
Sale (:qbpos)

```ruby
q = Qbxml.new(:qb)
```

### API Introspection

Return all types defined in the schema

```ruby
q.types
```

Return all types matching a certain pattern

```ruby
q.types('Customer')

q.types(/Customer/)
```

Print the xml template for a specific type

```ruby
puts q.describe('CustomerModRq')
```

### QBXML To Ruby

Convert valid QBXML to a ruby hash

```ruby
q.from_qbxml(xml)
```

### Ruby To QBXML

Convert a ruby hash to QBXML, skipping validation

```ruby
q.to_qbxml(hsh)
```

Convert a ruby hash to QBXML and validate all types

```ruby
q.to_qbxml(hsh, validate: true)
```

Convert a ruby hash to QBXML with line items:
```ruby
  {
    line_items: [
    {
      invoice_line_add: {
        desc: "Line 1"
      }
    },
    {
      invoice_line_add: {
        desc: "Line 2"
      }
    }
    ]
  }
```

The `line_items` will be omitted in the final XML yielding a proper:
```xml
<InvoiceAddRq>
    <InvoiceLineAdd>
      <Desc>Line 1</Desc>
    </InvoiceLineAdd>
    <InvoiceLineAdd>
      <Desc>Line 2</Desc>
    </InvoiceLineAdd>
</InvoiceAddRq>
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
