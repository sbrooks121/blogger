class ArticlesController < ApplicationController
  before_action :require_login, except: [:index, :show]

  include ArticlesHelper

  def index
    @articles = Article.last(10)
    respond_to do |format|
      format.html
      format.rss { render :layout => false }
    end
  end

  def show
    @article = Article.find(params[:id])
    @article.increment_view_count

    @comment = Comment.new
    @comment.article_id = @article.id
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    @article.author = current_user
    @article.view_count = 0

    respond_to do |format|
      if @article.save
        flash[:success] = "Article '#{@article.title}' created!"
        format.html { redirect_to article_path(@article) }
        format.json { render :show, status: :created, location: @article }
      else
        flash[:alert] = 'There was a problem creating the article.'
        format.html { render :new }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end

  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])

    respond_to do |format|
      if @article.update(article_params)
        flash[:success] = "Article '#{@article.title}' updated!"
        format.html { redirect_to article_path(@article) }
        format.json { render :show, status: :ok, location: @article }
      else
        flash[:alert] = 'There was a problem updating the article.'
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @article = Article.find(params[:id])

    respond_to do |format|
      if @article.destroy
        flash[:success] = "Article '#{@article.title}' deleted!"
        format.html { redirect_to articles_path }
        format.json { render :show, status: :ok, location: @article }
      else
        flash[:alert] = 'There was a problem updating the article.'
        format.html { render :edit }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end
end
