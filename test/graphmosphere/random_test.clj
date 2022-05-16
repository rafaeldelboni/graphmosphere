(ns graphmosphere.random-test
  (:require [clojure.test :refer [are deftest is testing]]
            [graphmosphere.random :as rand]))

(deftest rand-seeded-test
  (testing "should return randon (seeded) numbers between range"
    (are [seed min max expected] (= expected (rand/double-seeded seed min max))
      ;seed min  max   expected
      1     5.0  5.0   5.0
      2     5.0  5.0   5.0
      1     5.0  10.0  8.654390953516454
      2     5.0  10.0  8.65573468009953
      2     5.0  100.0 74.45895892189105
      1     10.0 20.0  17.30878190703291)))

(deftest rand-gauss-seeded-test
  (testing "should return random Gaussian distribution with mean of 2 and standard deviation of 0.5"
    (is (= 2.7807905200944774
           (rand/gauss-seeded 1 2.0 0.5)))))
