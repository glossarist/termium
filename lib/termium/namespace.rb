# frozen_string_literal: true

module Termium
  class Namespace < Lutaml::Xml::Namespace
    uri "http://termium.tpsgc-pwgsc.gc.ca/schemas/2012/06/Termium"
    prefix_default "ns2"
    element_form_default :unqualified
    attribute_form_default :unqualified
  end
end
