require_relative '../../lib/everypay_v4_wrapper/params_separator'

RSpec.describe EverypayV4Wrapper::ParamsSeparator do
  describe 'should transform values of hash to separated string by symbol' do
    before do
      @params = {
        name: 'Oleg Hasjanov ',
        description: ' This is description '
      }
    end

    it('should separate hash by underscope and remove whitespace') do
      result = {
        name: 'oleg_hasjanov',
        description: 'this_is_description'
      }

      separated_hash = described_class.start_separate(params: @params)
      expect(separated_hash).to eq(result)
    end
  end
end