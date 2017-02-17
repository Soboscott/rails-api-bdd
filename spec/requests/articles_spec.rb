# frozen_string_literal: true
require 'rails_helper'
# calls method describe on rRSpec class
# passes a string to describe what text we are going to test

RSpec.describe 'Articles API' do
  #  defines artical params that return an object
  # with title and content
  def article_params
    {
      title: 'One Weird Trick',
      content: 'You won\'t believe what happens next...'
    }
  end

  # defines a function article that returns all articles
  def articles
    Article.all
  end

  # returns a function article that returns first articles
  def article
    Article.first
  end

  # befor you run all(any) the tests create an article params

  before(:all) do
    Article.create!(article_params)
  end
  #  after all tests are done delete garbage data created
  after(:all) do
    Article.delete_all
  end
  # tells us we are going to describs a GET request
  describe 'GET /articles' do
    # a GET request to /articles should list all the articles
    it 'lists all articles' do
      # makes a GET request to your API to /articles
      get '/articles'
      # I expect the responseto be Ccode) 2xx
      expect(response).to be_success
      # parsed the json response into a ruby hash
      # so we can test it (json isjust strings)
      articles_response = JSON.parse(response.body)
      # expects the response length to be the the same as number of articles
      expect(articles_response.length).to eq(articles.count)
      # expect the first article in the response t
      # o be the first article in the db
      expect(articles_response.first['title']).to eq(article['title'])
    end
  end

  describe 'GET /articles/:id' do
    it 'shows one article' do
      get "/articles/#{article.id}"

      expect(response).to be_success

      article_response = JSON.parse(response.body)
      expect(article_response['id']).to eq(article['id'])
      expect(article_response['title']).to eq(article['title'])
    end
  end

  describe 'DELETE /articles/:id' do
    it 'deletes an article' do
      article_id = article.id
      delete"/articles/#{article.id}"

      expect(response).to be_success
      expect(response.body).to be_empty
      expect { Article.find(article_id) }
        .to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe 'POST /articles' do
    def new_article
      {
        title: 'Rachel is sick',
        content: 'Kids are the problem.'
      }
    end
    it 'creates an article' do
      post '/articles/', params: { article: new_article }

      expect(response).to be_success

      article_response = JSON.parse(response.body)
      expect(article_response['id']).not_to be_nil
      expect(article_response['title']).to eq(new_article[:title])
    end
  end

  describe 'PATCH /articles/:id' do
    def article_diff
      { title: 'Two Stupid Tricks' }
    end

    it 'updates an article' do
      patch "/articles/#{article.id}", params: { article: article_diff }

      expect(response).to be_success

      expect(article[:title]).to eq(article_diff[:title])
    end
  end
end
