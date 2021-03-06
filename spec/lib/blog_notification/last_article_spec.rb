require 'blog_notification/last_article'

describe BlogNotification::LastArticle do

  let(:default_argument) {{
    title: 'Test title',
    url: 'https://example.com/',
    last_update: Time.parse('2018-01-01 00:00:00 +0900'),
  }}

  describe "#initialize" do

    let(:last_article) {
      BlogNotification::LastArticle.new(
          **{
          title: 'Test title',
          url: 'https://example.com/',
          last_update: '2018-01-01 00:00:00 +0900',
        })
    }

    context 'last_update pass String' do
      it 'parsed time' do
        expect(last_article.last_update).to be_a Time
        expect(last_article.last_update.to_s).to eq '2018-01-01 00:00:00 +0900'
      end
    end
  end

  describe '#to_h' do

    let(:last_article) { BlogNotification::LastArticle.new(**default_argument) }

    it 'return hash' do
      expect(last_article.to_h).to be_a Hash
    end

    it 'eq title' do
      expect(last_article.to_h[:title]).to eq 'Test title'
    end

    it 'eq url' do
      expect(last_article.to_h[:url]).to eq 'https://example.com/'
    end

    it 'eq last_update' do
      expect(last_article.to_h[:last_update].to_s).to eq '2018-01-01 00:00:00 +0900'
    end
  end

  describe '#[]' do

    let(:last_article) { BlogNotification::LastArticle.new(**default_argument) }

    context 'access with String' do
      it 'access title' do
        expect(last_article['title']).to eq 'Test title'
      end

      it 'access url' do
        expect(last_article['url']).to eq 'https://example.com/'
      end

      it 'access last_update' do
        expect(last_article['last_update'].to_s).to eq '2018-01-01 00:00:00 +0900'
      end

      it 'access nothing attr' do
        expect(last_article['example']).to be_nil
      end
    end

    context 'access with Symbol' do
      it 'access title' do
        expect(last_article[:title]).to eq 'Test title'
      end

      it 'access url' do
        expect(last_article[:url]).to eq 'https://example.com/'
      end

      it 'access last_update' do
        expect(last_article[:last_update].to_s).to eq '2018-01-01 00:00:00 +0900'
      end

      it 'access nothing attr' do
        expect(last_article[:example]).to be_nil
      end
    end

  end

end