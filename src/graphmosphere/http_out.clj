(ns graphmosphere.http-out
  (:require [cheshire.core]
            [clj-http.client :as http]))

(set! *warn-on-reflection* true)

(defn request!
  [{:keys [url body] :as payload} headers]
  (http/check-url! url)
  (http/request (-> payload
                    (merge {:as :json
                            :form-params body
                            :headers headers
                            :cookie-policy :default})
                    (dissoc :body))))
