module Api
  module V1
    class FeaturesController < ApplicationController
      # Antes de ejecutar las acciones 'show' y 'create_comment', se ejecuta 'set_feature'
      before_action :set_feature, only: [:show, :create_comment]

      # Acción para recuperar todas las características disponibles
#      def index
#        @features = Feature.all
#        render json: @features
#      end

      # Acción para recuperar todas las características disponibles con paginación y filtro por mag_type
      def index
#        features = Feature.all
        features = Feature.includes(:comments).all  # Cargar características y sus comentarios asociados

        # Aplicar filtro por mag_type si se proporciona
        if params[:filters] && params[:filters][:mag_type]
          features = features.where('mag_type = ?', params[:filters][:mag_type])
        end

        # Paginar resultados
        features = features.page(params[:page]).per(params[:per_page] || 20)

        # Renderizar respuesta con los datos filtrados y paginados
#        render json: { data: features, pagination: pagination_dict(features) }
        # Renderizar respuesta con los datos filtrados, paginados y comentarios incluidos
        render json: { data: features.as_json(include: :comments), pagination: pagination_dict(features) }
      end

      def show
        render json: @feature
      end

      def create_comment
        # Se crea un nuevo comentario para la característica
        @comment = @feature.comments.new(comment_params)
        # Si el comentario se guarda exitosamente
        if @comment.save
          render json: @comment, status: :created  # Devuelve el comentario creado con estado 'created'
        else
          render json: @comment.errors, status: :unprocessable_entity  # Devuelve errores si la creación falla
        end
      end


      private

      # Método para configurar la variable de instancia '@feature'
      def set_feature
        @feature = Feature.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Feature not found' }, status: :not_found
      end

      # Método para definir los parámetros permitidos para crear un comentario
      def comment_params
        params.require(:comment).permit(:body)
      end

      # Método auxiliar para construir los metadatos de paginación
      def pagination_dict(collection)
        {
          current_page: collection.current_page,
          next_page: collection.next_page,
          prev_page: collection.prev_page,
          total_pages: collection.total_pages,
          total_count: collection.total_count
        }
      end
    end
  end
end
