(ns immutant-server.core
  (:require [immutant.web :as web])
  (:gen-class))

(def hello
  {:status 200
   :headers {"content-type" "text/plain; charset=utf-8"}
   :body (.getBytes "Hello World")})

(defn app [req]
  (let [uri (:uri req)]
    (cond
      (.equals "/" uri) hello
      :else {:status 404})))

(defn -main [& _]
  (web/run
    app
    {:port 9292
     :host "0.0.0.0"
     :dispatch? false
     :server {:always-set-keep-alive false}}))
