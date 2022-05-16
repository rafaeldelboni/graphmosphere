(ns graphmosphere.hmac
  (:import [java.util Base64]
           [javax.crypto Mac]
           [javax.crypto.spec SecretKeySpec]))

(set! *warn-on-reflection* true)

(defn ^:private return-signing-key
  "Get an hmac key from the raw key bytes given some 'mac' algorithm.
  Known 'mac' options: HmacSHA1"
  [^String key ^Mac mac]
  (SecretKeySpec. (.getBytes key) (.getAlgorithm mac)))

(defn ^:private sign-to-bytes
  "Returns the byte signature of a string with a given key, using a SHA1 HMAC."
  [^String key ^String string]
  (let [mac (Mac/getInstance "HmacSHA1")
        secretKey (return-signing-key key mac)]
    (-> (doto mac
          (.init secretKey)
          (.update (.getBytes string)))
        .doFinal)))

(defn ^:private bytes-to-base64str
  "Encode bytes to Base64"
  [bytes]
  (.encodeToString (Base64/getEncoder) bytes))

(defn sign-to-base64str
  "Returns the HMAC SHA1 hex string signature from a key-string pair."
  [^String key ^String string]
  (bytes-to-base64str (sign-to-bytes key string)))
