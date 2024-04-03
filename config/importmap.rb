# Pin npm packages by running ./bin/importmap

pin "application"
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js"
pin_all_from "app/javascript/controllers", under: "controllers"
pin "jquery" # @3.7.1
pin "wicket" # @1.3.8
pin "leaflet" # @1.9.4
pin "flatpickr" # @4.6.13
pin "slim-select" # @2.8.2
