class CommentsController < ApplicationController
  before_action :require_login, except: [:create]

  def create
    @comment = Comment.new(comment_params)
    @comment.article_id = params[:article_id]

    respond_to do |format|
      if @comment.save
        format.html { redirect_to article_path(@comment.article) }
        format.json { render :show, status: :created, location: @article }
      else
        flash[:alert] = 'There was a problem creating the comment.'
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def comment_params
    params.require(:comment).permit(:author_name, :body)
  end
end
