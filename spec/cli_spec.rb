require 'spec_helper'

describe FontelloRailsConverter::Cli do
  let(:options) {{
    config_file: 'spec/fixtures/fontello/config.json',
    stylesheet_dir: 'vendor/assets/stylesheets'
  }}
  let(:cli) { described_class.new(options)
  }

  describe '#convert_icon_guide_html' do
    let(:content) { File.read('spec/fixtures/fontello-demo.html') }
    let(:converted_content) { File.read('spec/fixtures/converted/fontello-demo.html') }
    let(:options){{
      assets_prefix_css: '/assets',
      assets_prefix_fonts: '/assets'
    }}

    specify do
      expect(cli.send(:convert_icon_guide_html, content)).to eql converted_content
    end
  end

  describe '#stylesheet_file' do
    specify do
      expect(cli.send(:stylesheet_file)).to eql 'vendor/assets/stylesheets/test.css'
    end

    context '.scss extension' do
      specify do
        expect(cli.send(:stylesheet_file, extension: '.scss')).to eql 'vendor/assets/stylesheets/test.scss'
      end
    end

    context 'with postfix' do
      specify do
        expect(cli.send(:stylesheet_file, postfix: '-embedded', extension: '.scss')).to eql 'vendor/assets/stylesheets/test-embedded.scss'
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
        expect(cli.send(:fontello_name)).to eql 'test'
      end
    end
  end
end