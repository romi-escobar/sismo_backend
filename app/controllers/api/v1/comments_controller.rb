module Api
  module V1
    class CommentsController < ApplicationController
      before_action :find_feature

      def index
        @comments = @feature.comments
        render json: @comments
      end

      def create
        @feature = Feature.find(params[:feature_id])
        @comment = @feature.comments.build(comment_params)

        if @comment.save
          render json: @comment, status: :created
        else
          render json: @comment.errors, status: :unprocessable_entity
        end
      end

      private

      def find_feature
        @feature = Feature.find(params[:feature_id])
      end

      def comment_params
        params.require(:comment).permit(:body) # Asegúrate de incluir cualquier otro campo que necesites permitir
      end
    end
  end
end
