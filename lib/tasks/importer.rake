namespace :importer do
  task :import_zones_fromCSV, [:file] => :environment do |_, args|
    CSV.foreach("db/data/deptos.csv", headers: true) do |feature|
      p "Import depto #{feature["admlnm"]}"
      Zone.find_or_create_by({
        ztype: 1,
        geometry: feature["WKT"],
        name: feature["admlnm"]
      })
    end
    CSV.foreach("db/data/localidades.csv", headers: true) do |feature|
      p "Import localidad #{feature["localidad"]}"
      parent = Zone.search_name(feature["departamen"]).first
      if parent.present?
        Zone.find_or_create_by({
          ztype: 3,
          geometry: feature["wkt"],
          name: feature["localidad"],
          parent_zone: parent
        })
      else
        p "PARENT NOT FOUND #{feature["departamen"]}"
      end
    end
  end
end
