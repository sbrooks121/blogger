class ArticlesController < ApplicationController
  before_action :require_login, except: [:index, :show]

  include ArticlesHelper

  def index
    @articles = Article.all
    respond_to do |format|
      format.html
      format.rss { render :layout => false }
    end
  end

  def popular
    @articles = Article.all.order(view_count: :desc)
    respond_to do |format|
      format.html
    end
  end

  def show
    article.increment_view_count

    @comment = Comment.new
    @comment.article_id = article.id
  end

  def new
  end

  def create
    article = Article.new(article_params)
    article.author = current_user
    article.view_count = 0

    respond_to do |format|
      if article.save
        flash[:success] = "Article '#{article.title}' created!"
        format.html { redirect_to article_path(article) }
        format.json { render :show, status: :created, location: article }
      else
        flash[:alert] = 'There was a problem creating the article.'
        format.html { render :new }
        format.json { render json: article.errors, status: :unprocessable_entity }
      end
    end

  end

  def edit
  end

  def update
    respond_to do |format|
      if article.update(article_params)
        flash[:success] = "Article '#{article.title}' updated!"
        format.html { redirect_to article_path(article) }
        format.json { render :show, status: :ok, location: article }
      else
        flash[:alert] = 'There was a problem updating the article.'
        format.html { render :edit }
        format.json { render json: article.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if article.destroy
        flash[:success] = "Article '#{article.title}' deleted!"
        format.html { redirect_to articles_path }
        format.json { render :show, status: :ok, location: article }
      else
        flash[:alert] = 'There was a problem deleting the article.'
        format.html { render :edit }
        format.json { render json: article.errors, status: :unprocessable_entity }
      end
    end
  end

  def article
    @cached_article ||= Article.find_or_initialize_by(params[:id])
  end

  helper_method :article

end
