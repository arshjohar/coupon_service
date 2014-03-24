require 'spec_helper'

class DummyClass
  include BlankParamsChecker
end

describe BlankParamsChecker do
  describe '#get_blank_params' do
    it 'checks for mandatory params and returns an array containing params that are blank' do
      params = {nil_param: nil, some_other_required_param: 'abc', non_required_param: nil}.with_indifferent_access

      dummy_instance = DummyClass.new

      expect(dummy_instance.get_blank_params(params, 'nil_param', 'some_other_required_param')).to eq(%w(nil_param))
    end
  end
end
