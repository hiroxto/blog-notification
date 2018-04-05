require 'trysail_blog_notification/last_article'

describe TrySailBlogNotification::LastArticle do

  let(:title) { 'Test title' }
  let(:url) { 'https://hiroto-k.net/' }
  let(:last_update) { '2018-02-08' }
  let(:default_argument) {{
    title: title,
    url: url,
    last_update: last_update,
  }}

  describe '#to_h' do

    let(:last_article) { TrySailBlogNotification::LastArticle.new(default_argument) }

    it 'return hash' do
      expect(last_article.to_h).to be_a Hash
    end

    it 'eq title' do
      expect(last_article.to_h[:title]).to eq title
    end

    it 'eq url' do
      expect(last_article.to_h[:url]).to eq url
    end

    it 'eq last_update' do
      expect(last_article.to_h[:last_update]).to eq last_update
    end
  end

  describe '#[]' do

    let(:last_article) { TrySailBlogNotification::LastArticle.new(default_argument) }

    context 'access with String' do
      it 'access title' do
        expect(last_article['title']).to eq title
      end

      it 'access url' do
        expect(last_article['url']).to eq url
      end

      it 'access last_update' do
        expect(last_article['last_update']).to eq last_update
      end

      it 'access nothing attr' do
        expect(last_article['example']).to be_nil
      end
    end

    context 'access with Symbol' do
      it 'access title' do
        expect(last_article[:title]).to eq title
      end

      it 'access url' do
        expect(last_article[:url]).to eq url
      end

      it 'access last_update' do
        expect(last_article[:last_update]).to eq last_update
      end

      it 'access nothing attr' do
        expect(last_article[:example]).to be_nil
      end
    end

  end

end