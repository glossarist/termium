# frozen_string_literal: true

RSpec::Matchers.define_negated_matcher :exclude, :include
RSpec::Matchers.define_negated_matcher :preserve, :change
