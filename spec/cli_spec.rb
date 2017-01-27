require 'spec_helper'

describe FontelloRailsConverter::Cli do
  let(:cli) { described_class.new({
      config_file: 'spec/fixtures/fontello/config.json',
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

  describe '#convert_for_asset_pipeline' do
    specify do
      expect(cli.send(:convert_for_asset_pipeline, "url(/this/is/a/link)")).to eql 'font-url(/this/is/a/link)'
    end

    specify do
      expect(cli.send(:convert_for_webpack, "url(/this/is/a/link)")).to eql 'url(~/this/is/a/link)'
    end

    specify do
      expect(cli.send(:convert_for_webpack, "url('/this/is/a/link')")).to eql %q[url('~/this/is/a/link')]
    end

    specify do
      expect(cli.send(:convert_for_asset_pipeline, "url(data:application/octet-stream;base64,FFF)")).to eql 'url(data:application/octet-stream;base64,FFF)'
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

  describe '#copy_config_json' do
    let(:zipfile) { instance_double('FontelloZipfile') }
    let(:config_file_path) { 'test/config.json' }

    subject {
      cli.send(:copy_config_json, zipfile, config_file_path)
    }

    specify do
      expect(zipfile).to receive(:extract).with(config_file_path, 'spec/fixtures/fontello/config.json')
      subject
    end
  end
end
