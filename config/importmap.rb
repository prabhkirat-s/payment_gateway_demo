# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "bootstrap", to: "bootstrap.min.js", preload: true
pin "@popperjs/core", to: "popper.js", preload: true
pin "jquery", to: "https://ga.jspm.io/npm:jquery@3.7.1/dist/jquery.js"
pin "@stripe/stripe-js", to: "https://ga.jspm.io/npm:@stripe/stripe-js@2.2.0/dist/stripe.esm.js"
