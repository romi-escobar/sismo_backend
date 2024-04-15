namespace :usgs do
  desc "Fetch and persist earthquake data from USGS"
  task fetch_data: :environment do
    require 'httparty'

    url = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.geojson"
    response = HTTParty.get(url)
    features = JSON.parse(response.body)["features"]

    features_to_save = []

    features.each do |feature|
      coords = feature["geometry"]["coordinates"]
      props = feature["properties"]

      next if coords[0].nil? || coords[1].nil? || props["mag"].nil? || props["place"].nil? || props["magType"].nil? || props["title"].nil?
      next unless props["mag"].between?(-1.0, 10.0) && coords[1].between?(-90.0, 90.0) && coords[0].between?(-180.0, 180.0)

      features_to_save << Feature.new(
        external_id: feature["id"],
        magnitude: props["mag"],
        place: props["place"],
        time: Time.at(props["time"] / 1000),
        tsunami: props["tsunami"] == 1,
        mag_type: props["magType"],
        title: props["title"],
        url: props["url"],
        longitude: coords[0],
        latitude: coords[1]
      )
    end

    Feature.import(features_to_save, on_duplicate_key_ignore: true)
    puts "#{features_to_save.size} features imported."
  end
end
