(ns ring_server.core
  (:require [ring.adapter.jetty :as jetty]))

(defn handler [request]
  {:status 200
   :headers {"Content-Type" "text/pain"}
   :body "Hello World"})

(defn -main []
  (jetty/run-jetty handler {:port 9292}))
