require 'spec_helper'

describe FontelloRailsConverter::Cli do
  let(:cli) { described_class.new({
      config_file: 'spec/fixtures/config.json',
      stylesheet_dir: 'vendor/assets/stylesheets'
    })
  }

  describe '.convert_icon_guide_html' do
    let(:content) { File.read('spec/fixtures/fontello-demo.html') }
    let(:converted_content) { File.read('spec/fixtures/converted/fontello-demo.html') }

    specify do
      expect(described_class.convert_icon_guide_html(content)).to eql converted_content
    end
  end

  describe '#main_stylesheet_file' do
    specify do
      expect(cli.send(:main_stylesheet_file)).to eql 'vendor/assets/stylesheets/makerist.css'
    end

    context '.scss extension' do
      specify do
        expect(cli.send(:main_stylesheet_file, extension: '.scss')).to eql 'vendor/assets/stylesheets/makerist.scss'
      end
    end
  end

  describe '#fontello_name' do
    context 'no config_file specified' do
      let(:cli) { described_class.new({}) }
      specify do
        expect(cli.send(:fontello_name)).to eql nil
      end
    end

    context 'specified config file doesnt exist' do
      let(:cli) { described_class.new(config_file: 'foo') }
      specify do
        expect(cli.send(:fontello_name)).to eql nil
      end
    end

    context 'name is empty' do
      let(:cli) { described_class.new(config_file: 'spec/fixtures/empty_name_config.json') }
      it 'should fall back to "fontello"' do
        expect(cli.send(:fontello_name)).to eql 'fontello'
      end
    end

    context 'correct config file' do

      specify do
        expect(cli.send(:fontello_name)).to eql 'makerist'
      end
    end
  end
end