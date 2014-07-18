module Qbxml::Types

  XML_DIRECTIVES = { 
    :qb => [:qbxml, { version: '7.0' }],
    :qbpos => [:qbposxml, { version: '3.0' }]
  }.freeze

  FLOAT_CAST = Proc.new {|d| d ? Float(d) : 0.0}
  MONEY_CAST = Proc.new {|d| '%.2f' % (d ? Float(d) : 0.0)}
  BOOL_CAST  = Proc.new {|d| d ? (d.downcase == 'true' ? true : false) : false }
  DATE_CAST  = Proc.new {|d| d ? Date.parse(d).strftime("%Y-%m-%d") : Date.today.strftime("%Y-%m-%d") }
  TIME_CAST  = Proc.new {|d| d ? Time.parse(d).xmlschema : Time.now.xmlschema }
  INT_CAST   = Proc.new {|d| d ? Integer(d.to_i) : 0 }
  STR_CAST   = Proc.new {|d| d ? String(d) : ''}

  TYPE_MAP= {
    "AMTTYPE"          => MONEY_CAST,
    "BOOLTYPE"         => BOOL_CAST,
    "DATETIMETYPE"     => TIME_CAST,
    "DATETYPE"         => DATE_CAST,
    "ENUMTYPE"         => STR_CAST,
    "FLOATTYPE"        => FLOAT_CAST,
    "GUIDTYPE"         => STR_CAST,
    "IDTYPE"           => STR_CAST,
    "INTTYPE"          => INT_CAST,
    "PERCENTTYPE"      => FLOAT_CAST,
    "PRICETYPE"        => FLOAT_CAST,
    "QUANTYPE"         => INT_CAST,
    "STRTYPE"          => STR_CAST,
    "TIMEINTERVALTYPE" => STR_CAST
  }

  ACRONYMS = [/Ap\z/, /Ar/, /Cogs/, /Com\z/, /Uom/, /Qbxml/, /Ui/, /Avs/, /Id\z/,
              /Pin/, /Ssn/, /Clsid/, /Fob/, /Ein/, /Uom/, /Po\z/, /Pin/, /Qb/]
end
