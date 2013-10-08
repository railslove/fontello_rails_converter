require 'spec_helper'

describe FontelloRailsConverter::FontelloApi do
  subject { described_class.new config_file: File.expand_path('../fixtures/minimal-config.json', __FILE__) }

  describe '#session_url' do
    before do
      subject.should_receive(:session_id).and_return "12345"
    end

    specify do
      expect(subject.session_url).to eql 'http://fontello.com/12345'
    end
  end

  describe '#download_zip_body' do
    it 'should be a long string with the body of the zip file' do
      zip_body = subject.download_zip_body
      expect(zip_body).to be_instance_of String
      expect(zip_body).to include "makerist.ttf"
    end
  end
end