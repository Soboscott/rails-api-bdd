# frozen_string_literal: true
require 'rails_helper'

RSpec.describe ArticlesController do
  def article_params
    {
      title: 'One Weird Trick',
      content: 'You won\'t believe what happens next...'
    }
  end

  def article
    Article.first
  end

  before(:all) do
    Article.create!(article_params)
  end

  after(:all) do
    Article.delete_all
  end

  describe 'GET index' do
    before(:each) { get :index }

    it 'is succesful' do
      expect(response.status).to eq(200)
    end

    it 'renders a JSON response' do
      articles_collection = JSON.parse(response.body)
      expect(articles_collection).not_to be_nil
      expect(articles_collection.first['title']).to eq(article['title'])
    end
  end

  describe 'GET show' do
    before(:each) { get :show, params: { id: article.id } }
    it 'is successful' do
      expect(response.status).to eq(200)
    end

    it 'renders a JSON response' do
      parsed_article = JSON.parse(response.body)
      expect(parsed_article).not_to be_empty
    end
  end

  describe 'DELETE destroy' do
    it 'is successful and returns an empty response' do
      delete :destroy, id: article.id
      expect(response.status).to eq(204)
      expect(response.body).to be_empty
    end
  end

  describe 'PATCH update' do
    def article_diff
      { title: 'Two Stupid Tricks' }
    end

    before(:each) do
      patch :update, params: { id: article.id, article: article_diff }
    end

    it 'is successful' do
      expect(response.status).to eq(204)
    end

    it 'returns an empty response' do
      expect(response.body).to be_empty
    end
    it 'updates an article' do
      expect(article[:title]).to eq(article_diff[:title])
    end
  end
  describe 'POST create' do
    def new_article
      {
        title: 'Testing iz gr8',
        content: 'Except when it\'s not'
      }
    end
    before(:each) do
      post :create, params: { article: new_article }, format: :json
    end

    it 'is successful' do
      expect(response.status).to eq(201)
    end

    it 'renders a JSON response' do
      article_response = JSON.parse(response.body)
      expect(article_response).not_to be_nil
    end
  end
end
