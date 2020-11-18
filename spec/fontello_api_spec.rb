require 'spec_helper'

describe FontelloRailsConverter::FontelloApi do
  context 'no persistence' do
    subject { described_class.new config_file: File.expand_path('../fixtures/minimal-config.json', __FILE__), fontello_session_id_file: File.expand_path('../fixtures/fontello_session_id_persisted', __FILE__) }

    before do
      allow(subject).to receive(:persist_session)
    end

    describe '#new_session_from_config' do
      before do
        expect(RestClient).to receive(:post).and_return 'NEWIDFROMCONFIG'
      end

      specify do
        expect(subject).to receive(:persist_session)
        expect(subject.new_session_from_config).to eql 'NEWIDFROMCONFIG'
      end
    end

    describe '#session_url' do
      before do
        expect(subject).to receive(:session_id).and_return "12345"
      end

      specify do
        expect(subject.session_url).to eql 'https://fontello.com/12345'
      end
    end

    describe '#download_zip_body' do
      before do
        subject.new_session_from_config # from config
      end
      it 'should be a long string with the body of the zip file' do
        zip_body = subject.download_zip_body
        expect(zip_body).to be_instance_of String
        expect(zip_body).to include "makerist.ttf"
      end
    end

    describe '#session_id' do
      context 'session_id NOT set on initialization' do
        specify do
          expect(subject).to receive(:read_or_create_session).and_return 'foo'
          expect(subject.send(:session_id)).to eql 'foo'
        end
      end

      context 'session_id set on initialization' do
        subject { described_class.new fontello_session_id: '0192837465' }

        specify do
          expect(subject.send(:session_id)).to eql '0192837465'
        end
      end
    end

    describe '#read_or_create_session' do
      context 'read from existing file' do
        specify do
          expect(subject).not_to receive(:new_session_from_config)
          expect(subject.send(:read_or_create_session)).to eql 'MYPERSISTEDSESSION'
        end
      end

      context 'file does NOT exist' do
        before do
          subject.instance_variable_set :@fontello_session_id_file, '/does/not/exist'
        end

        specify do
          expect(subject).to receive(:new_session_from_config).and_return 'NEWSESSION'
          expect(subject.send(:read_or_create_session)).to eql 'NEWSESSION'
        end
      end

      context 'file is empty' do
        before do
          subject.instance_variable_set :@fontello_session_id_file, File.expand_path('../fixtures/fontello_session_id_empty', __FILE__)
        end

        specify do
          expect(subject).to receive(:new_session_from_config).and_return 'NEWSESSION'
          expect(subject.send(:read_or_create_session)).to eql 'NEWSESSION'
        end
      end
    end
  end

  context 'with persistence' do
    subject { described_class.new fontello_session_id: 'MYID', fontello_session_id_file: File.expand_path('../fixtures/fontello_session_id_changing', __FILE__) }

    describe '#persist_session' do
      specify do
        subject.send(:persist_session)
        expect(subject.send(:read_or_create_session)).to eql 'MYID'
      end
    end
  end
end