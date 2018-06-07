(defproject immutant_server "0.1.0-SNAPSHOT"
  :description "A plain text immutant server"
  :dependencies [[org.clojure/clojure "1.9.0"]
                 [ikitommi/immutant-web "3.0.0-alpha1"]]
  :main ^:skip-aot immutant-server.core
  :target-path "target/%s"
  :profiles {:uberjar {:aot :all}})
