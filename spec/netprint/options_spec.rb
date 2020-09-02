require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

include Netprint

describe Options do
  subject do
    Options.new(options)
  end

  let(:options) { {} }

  describe '#apply' do
    context 'default' do
      it do
        form = Object.new
        expect(form).to be_checked('yus-size', PAPERSIZE::A4)
        expect(form).to be_checked('iro-cl', COLOR::BW)
        expect(form).to be_checked('yyk-type-cl', CODE_TYPE::ALNUM)
        expect(form).to be_checked('pin-num-set-fl', '0')
        expect(form).to be_checked('notice-onoff', '0')

        expect(form).not_to receive(:[]=)

        subject.apply(form)
      end
    end

    context 'with secret code' do
      let(:options) { { :secret_code => '0123' } }

      it do
        form = Object.new
        expect(form).to be_checked('yus-size', PAPERSIZE::A4)
        expect(form).to be_checked('iro-cl', COLOR::BW)
        expect(form).to be_checked('yyk-type-cl', CODE_TYPE::ALNUM)
        expect(form).to be_checked('pin-num-set-fl', '1')
        expect(form).to be_checked('notice-onoff', '0')

        expect(form).to receive(:[]=).with('pin-no', '0123')

        subject.apply(form)
      end
    end

    context 'with email' do
      let(:options) { { :email => 'test@example.com' } }

      it do
        form = Object.new
        expect(form).to be_checked('yus-size', PAPERSIZE::A4)
        expect(form).to be_checked('iro-cl', COLOR::BW)
        expect(form).to be_checked('yyk-type-cl', CODE_TYPE::ALNUM)
        expect(form).to be_checked('pin-num-set-fl', '0')
        expect(form).to be_checked('notice-onoff', '1')

        expect(form).to receive(:[]=).with('mail-adr-to-tx', 'test@example.com')

        subject.apply(form)
      end
    end

    context 'with paper size' do
      let(:options) { { :paper_size => PAPERSIZE::B4 } }

      it do
        form = Object.new
        expect(form).to be_checked('yus-size', PAPERSIZE::B4)
        expect(form).to be_checked('iro-cl', COLOR::BW)
        expect(form).to be_checked('yyk-type-cl', CODE_TYPE::ALNUM)
        expect(form).to be_checked('pin-num-set-fl', '0')
        expect(form).to be_checked('notice-onoff', '0')

        expect(form).not_to receive(:[]=)

        subject.apply(form)
      end
    end

    context 'with color' do
      let(:options) { { :color => COLOR::COLOR } }

      it do
        form = Object.new
        expect(form).to be_checked('yus-size', PAPERSIZE::A4)
        expect(form).to be_checked('iro-cl', COLOR::COLOR)
        expect(form).to be_checked('yyk-type-cl', CODE_TYPE::ALNUM)
        expect(form).to be_checked('pin-num-set-fl', '0')
        expect(form).to be_checked('notice-onoff', '0')

        expect(form).not_to receive(:[]=)

        subject.apply(form)
      end
    end

    context 'with code type' do
      let(:options) { { :code_type => CODE_TYPE::NUM } }

      it do
        form = Object.new
        expect(form).to be_checked('yus-size', PAPERSIZE::A4)
        expect(form).to be_checked('iro-cl', COLOR::BW)
        expect(form).to be_checked('yyk-type-cl', CODE_TYPE::NUM)
        expect(form).to be_checked('pin-num-set-fl', '0')
        expect(form).to be_checked('notice-onoff', '0')

        expect(form).not_to receive(:[]=)

        subject.apply(form)
      end
    end

    context 'with all options' do
      let(:options) {
        {
          :paper_size  => PAPERSIZE::B5,
          :color       => COLOR::SELECT_WHEN_PRINT,
          :code_type   => CODE_TYPE::NUM,
          :secret_code => '0987',
          :email       => 'foo@example.com'
        }
      }

      it do
        form = Object.new
        expect(form).to be_checked('yus-size', PAPERSIZE::B5)
        expect(form).to be_checked('iro-cl', COLOR::SELECT_WHEN_PRINT)
        expect(form).to be_checked('yyk-type-cl', CODE_TYPE::NUM)
        expect(form).to be_checked('pin-num-set-fl', '1')
        expect(form).to be_checked('notice-onoff', '1')

        expect(form).to receive(:[]=).with('pin-no', '0987')
        expect(form).to receive(:[]=).with('mail-adr-to-tx',   'foo@example.com')

        subject.apply(form)
      end
    end
  end
end
