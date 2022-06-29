# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "trix", to: "https://ga.jspm.io/npm:trix@2.0.0-beta.0/dist/trix.js"
pin "@rails/actiontext", to: "https://ga.jspm.io/npm:@rails/actiontext@6.0.5/app/javascript/actiontext/index.js"
pin "@rails/activestorage", to: "https://ga.jspm.io/npm:@rails/activestorage@6.1.6/app/assets/javascripts/activestorage.js"
pin "emoji-picker-element", to: "https://ga.jspm.io/npm:emoji-picker-element@1.12.1/index.js"
pin "@popperjs/core", to: "https://ga.jspm.io/npm:@popperjs/core@2.11.5/dist/esm/index.js"
