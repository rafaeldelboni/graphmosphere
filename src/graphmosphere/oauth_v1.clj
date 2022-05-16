(ns graphmosphere.oauth-v1
  (:require [clojure.string :as string]
            [graphmosphere.hmac :as hmac]
            [graphmosphere.percent-encode :as percent-encode])
  (:import [java.security SecureRandom]
           [java.util Random]))

(set! *warn-on-reflection* true)

(def ^:private default-parameters
  {:oauth_signature_method "HMAC-SHA1"
   :oauth_version "1.0"})

(defn nonce
  "Random string for OAuth requests."
  []
  (let [length 30]
    (.toString (BigInteger. (int (* 5 length))
                            ^Random (SecureRandom/getInstance "SHA1PRNG"))
               32)))

(defn timestamp
  "Returns the current OAuth timestamp. The current time in seconds
  since the Unix epoch."
  []
  (int (/ (System/currentTimeMillis) 1000)))

(defn payload->parameter-string
  "Returns a string with all of the parameters included in the request, secrets,
  nonce and timestamp, all url percent encoded."
  [{:keys [body query-params]}
   {:keys [api-key access-token]}
   {:keys [nonce timestamp]}]
  (->> {:oauth_consumer_key api-key
        :oauth_nonce nonce
        :oauth_timestamp timestamp
        :oauth_token access-token}
       (merge default-parameters query-params body)
       (into (sorted-map))
       (mapv (fn [[k v]] (str (-> k name percent-encode/str->encode)
                              "="
                              (percent-encode/str->encode v))))

       (string/join "&")))

(defn parameter-string->signature-base-string
  "Adds in the beginning of the parameter string the method and url,
  also percent encoded."
  [parameter-string {:keys [url method]}]
  (->> [(-> method name string/upper-case) url parameter-string]
       (map #(percent-encode/str->encode %))
       (string/join "&")))

(defn calc-signature
  "Returns a base64 string with HMAC-SHA1 calculated signature of the request."
  [signature-base-string {:keys [api-key-secret access-token-secret]}]
  (-> (str api-key-secret "&" access-token-secret)
      (hmac/sign-to-base64str signature-base-string)))

(defn authorization-header
  [signature {:keys [api-key access-token]} {:keys [nonce timestamp]}]
  {"Authorization" (apply format "OAuth oauth_consumer_key=\"%s\", oauth_token=\"%s\", oauth_signature_method=\"%s\", oauth_timestamp=\"%s\", oauth_nonce=\"%s\", oauth_version=\"%s\", oauth_signature=\"%s\""
                          (map #(percent-encode/str->encode %)
                               [api-key
                                access-token
                                (:oauth_signature_method default-parameters)
                                timestamp
                                nonce
                                (:oauth_version default-parameters)
                                signature]))})

(defn payload->auth-header
  "Returns an authorization header OAuth v1 compliant"
  [payload secrets components]
  (-> (payload->parameter-string payload secrets components)
      (parameter-string->signature-base-string payload)
      (calc-signature secrets)
      (authorization-header secrets components)))
