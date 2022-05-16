(ns graphmosphere.random
  (:import [java.util Random]))

(set! *warn-on-reflection* true)

(defn double-seeded
  "Given an seed return a random number between min and max args"
  ^Double
  [^Long seed ^Double min ^Double max]
  (if (= min max)
    min
    (-> (Random. seed)
        (.doubles min max)
        .findFirst
        .getAsDouble)))

(defn gauss-seeded
  "Given an seed returns a random floating point value based on the given mean
  and standard deviation for the Gaussian distribution."
  ^Double
  [^Long seed ^Double mu ^Double sigma]
  (-> (Random. seed)
      .nextGaussian
      (* sigma)
      (+ mu)))
