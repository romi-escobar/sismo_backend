class Feature < ApplicationRecord
  # Asumiendo que Feature ya hereda de ApplicationRecord
  # y por lo tanto de ActiveRecord::Base

  # Validaciones para asegurar la presencia de ciertos campos.
  validates :title, :url, :place, :mag_type, :longitude, :latitude, presence: true

  # Validaciones para asegurar que el valor de magnitud esté en el rango permitido.
  validates :magnitude, numericality: { greater_than_or_equal_to: -1.0, less_than_or_equal_to: 10.0 }

  # Validaciones para asegurar que los valores de latitud y longitud estén en sus respectivos rangos permitidos.
  validates :latitude, numericality: { greater_than_or_equal_to: -90.0, less_than_or_equal_to: 90.0 }
  validates :longitude, numericality: { greater_than_or_equal_to: -180.0, less_than_or_equal_to: 180.0 }

  # Validación para asegurar que el `external_id` sea único, evitando así duplicados en la base de datos.
  validates :external_id, uniqueness: true

  # Relaciones (si las hubiera, por ejemplo con Comment)
  has_many :comments, dependent: :destroy
end
