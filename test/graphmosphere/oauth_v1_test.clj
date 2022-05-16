(ns graphmosphere.oauth-v1-test
  (:require [clojure.test :refer [deftest is testing]]
            [graphmosphere.oauth-v1 :as oauth]))

; Examples source: https://developer.twitter.com/en/docs/authentication/oauth-1-0a/creating-a-signature

(deftest payload->parameter-string-test
  (testing "Should return the sorted url encoded string of the parameters"
    (is (= "include_entities=true&oauth_consumer_key=xvz1evFS4wEEPTGEFPHBog&oauth_nonce=kYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg&oauth_signature_method=HMAC-SHA1&oauth_timestamp=1318622958&oauth_token=370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb&oauth_version=1.0&status=Hello%20Ladies%20%2B%20Gentlemen%2C%20a%20signed%20OAuth%20request%21"
           (oauth/payload->parameter-string
            {:method :post
             :url "https://api.twitter.com/1.1/statuses/update.json"
             :query-params {:include_entities true}
             :body {:status "Hello Ladies + Gentlemen, a signed OAuth request!"}}
            {:api-key "xvz1evFS4wEEPTGEFPHBog"
             :api-key-secret ""
             :access-token "370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb"
             :access-token-secret ""}
            {:nonce "kYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg"
             :timestamp "1318622958"})))))

(deftest parameter-string->signature-base-string-test
  (testing "Should return the sorted url encoded string of the parameters with Method and url"
    (is (= "POST&https%3A%2F%2Fapi.twitter.com%2F1.1%2Fstatuses%2Fupdate.json&include_entities%3Dtrue%26oauth_consumer_key%3Dxvz1evFS4wEEPTGEFPHBog%26oauth_nonce%3DkYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D1318622958%26oauth_token%3D370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb%26oauth_version%3D1.0%26status%3DHello%2520Ladies%2520%252B%2520Gentlemen%252C%2520a%2520signed%2520OAuth%2520request%2521"
           (oauth/parameter-string->signature-base-string
            "include_entities=true&oauth_consumer_key=xvz1evFS4wEEPTGEFPHBog&oauth_nonce=kYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg&oauth_signature_method=HMAC-SHA1&oauth_timestamp=1318622958&oauth_token=370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb&oauth_version=1.0&status=Hello%20Ladies%20%2B%20Gentlemen%2C%20a%20signed%20OAuth%20request%21"
            {:method :post
             :url "https://api.twitter.com/1.1/statuses/update.json"})))))

(deftest calc-signature-test
  (testing "Should generate keyed-hash message authentication code"
    (is (= "hCtSmYh+iHYCEqBWrE7C7hYmtUk="
           (oauth/calc-signature
            "POST&https%3A%2F%2Fapi.twitter.com%2F1.1%2Fstatuses%2Fupdate.json&include_entities%3Dtrue%26oauth_consumer_key%3Dxvz1evFS4wEEPTGEFPHBog%26oauth_nonce%3DkYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg%26oauth_signature_method%3DHMAC-SHA1%26oauth_timestamp%3D1318622958%26oauth_token%3D370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb%26oauth_version%3D1.0%26status%3DHello%2520Ladies%2520%252B%2520Gentlemen%252C%2520a%2520signed%2520OAuth%2520request%2521"
            {:api-key-secret "kAcSOqF21Fu85e7zjz7ZN2U4ZRhfV3WpwPAoE3Z7kBw"
             :access-token-secret "LswwdoUaIvS8ltyTt5jkRh4J50vUPVVHtR2YPi5kE"})))))

(deftest authorization-header-test
  (testing "Should return a map with the oauth0 header to clj-http"
    (is (= {"Authorization" "OAuth oauth_consumer_key=\"xvz1evFS4wEEPTGEFPHBog\", oauth_token=\"370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb\", oauth_signature_method=\"HMAC-SHA1\", oauth_timestamp=\"1318622958\", oauth_nonce=\"kYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg\", oauth_version=\"1.0\", oauth_signature=\"hCtSmYh%2BiHYCEqBWrE7C7hYmtUk%3D\""}
           (oauth/authorization-header
            "hCtSmYh+iHYCEqBWrE7C7hYmtUk="
            {:api-key "xvz1evFS4wEEPTGEFPHBog"
             :api-key-secret "kAcSOqF21Fu85e7zjz7ZN2U4ZRhfV3WpwPAoE3Z7kBw"
             :access-token "370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb"
             :access-token-secret "LswwdoUaIvS8ltyTt5jkRh4J50vUPVVHtR2YPi5kE"}
            {:nonce "kYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg"
             :timestamp "1318622958"})))))

(deftest payload->signature-test
  (testing "Should return a authorization header OAuth v1 compliant"
    (is (= {"Authorization" "OAuth oauth_consumer_key=\"xvz1evFS4wEEPTGEFPHBog\", oauth_token=\"370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb\", oauth_signature_method=\"HMAC-SHA1\", oauth_timestamp=\"1318622958\", oauth_nonce=\"kYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg\", oauth_version=\"1.0\", oauth_signature=\"hCtSmYh%2BiHYCEqBWrE7C7hYmtUk%3D\""}
           (oauth/payload->auth-header
            {:method :post
             :url "https://api.twitter.com/1.1/statuses/update.json"
             :query-params {:include_entities true}
             :body {:status "Hello Ladies + Gentlemen, a signed OAuth request!"}}
            {:api-key "xvz1evFS4wEEPTGEFPHBog"
             :api-key-secret "kAcSOqF21Fu85e7zjz7ZN2U4ZRhfV3WpwPAoE3Z7kBw"
             :access-token "370773112-GmHxMAgYyLbNEtIKZeRNFsMKPR9EyMZeS9weJAEb"
             :access-token-secret "LswwdoUaIvS8ltyTt5jkRh4J50vUPVVHtR2YPi5kE"}
            {:nonce "kYjzVBB8Y0ZFabxSWbWovY3uYSQ2pTgmZeNu2VS4cg"
             :timestamp "1318622958"})))))
