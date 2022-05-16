(ns graphmosphere.hmac-test
  (:require [clojure.test :refer [deftest is testing]]
            [graphmosphere.hmac :as hmac]))

(deftest str->encode-test
  (testing "Should generate keyed-hash message authentication code"
    (is (= "i81WMUgAk/CwC9By6tQsAy6zEFk="
           (hmac/sign-to-base64str "my-key" "my-data")))
    (is (= "ZleFVoaCOYbIdDYnMROXUgFMtgs="
           (hmac/sign-to-base64str "a" "b")))
    (is (= "hCtSmYh+iHYCEqBWrE7C7hYmtUk="
           (hmac/sign-to-base64str "kAcSOqF21Fu85e7zjz7ZN2U4ZRhfV3WpwPAoE3Z7kBw&LswwdoUaIvS8ltyTt5jkRh4J50vUPVVHtR2YPi5kE" "POST&https%3A%2F%2Fapi.twitter.com%2F1.1%2Fstatuses%2Fupdate.json&include_entities%3Dtrue%26oauth_consumer_key%3Dxvz1evFS4wEEPTGEFPHBog%26oauth_nonce%3DkYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D1318622958%26oauth_token%3D370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb%26oauth_version%3D1.0%26status%3DHello%2520Ladies%2520%252B%2520Gentlemen%252C%2520a%2520signed%2520OAuth%2520request%2521")))))
