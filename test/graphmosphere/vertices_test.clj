(ns graphmosphere.vertices-test
  (:require [clojure.test :refer [are deftest testing]]
            [graphmosphere.vertices :as vertices]))

(deftest clip-test
  (testing "should clip args into low & max values"
    (are [val lower upper expected] (= expected (vertices/clip val lower upper))
      ;val lower upper expected
      6.0  5.0   10.0  6.0
      4.0  5.0   10.0  5.0
      11.0 5.0   10.0  10.0)))
