(ns graphmosphere.vertices
  "Based on https://stackoverflow.com/a/25276331"
  (:require [graphmosphere.random :as rand]))

(set! *warn-on-reflection* true)

(defn clip
  "Given an interval, values outside the interval are clipped to the interval edges."
  ^Double
  [^Double val ^Double lower ^Double upper]
  (-> val
      (max lower)
      (min upper)))

(defn rand-angle-steps
  "Generates the division of a circumference in random angles."
  ^clojure.lang.PersistentVector
  [^Long seed ^Integer steps ^Double irregularity]
  (let [tau (* Math/PI 2)
        lower (-> tau (/ steps) (- irregularity))
        upper (-> tau (/ steps) (+ irregularity))
        angles (map #(rand/double-seeded (* seed %) lower upper) (range steps))
        cumulative (-> (reduce + angles) (/ (* 2 Math/PI)))]
    (map #(/ % cumulative) angles)))

(defn generate-polygon
  "Start with the center of the polygon at center, then creates the
   polygon by sampling points on a circle around the center.
   Random noise is added by varying the angular spacing between
   sequential points, and by varying the radial distance of each
   point from the centre."
  ^clojure.lang.PersistentVector
  [^Long seed
   ^clojure.lang.PersistentVector center
   ^Double avg-radius
   ^Double irregularity-in
   ^Double spikiness-in
   ^Integer num-vertices]
  (let [tau (* 2 Math/PI)
        irregularity (* irregularity-in (/ tau num-vertices))
        spikiness (* spikiness-in avg-radius)
        angle-steps (rand-angle-steps seed num-vertices irregularity)
        angle (rand/double-seeded seed 0.0 tau)]
    (->> angle-steps
         (reduce (fn [{:keys [sum-angle points]} cur]
                   (let [radius (-> (+ seed (count points))
                                    (rand/gauss-seeded avg-radius spikiness)
                                    (clip 0.0 (* 2 avg-radius)))
                         point [(-> (first center)
                                    (+ radius)
                                    (* (Math/cos sum-angle)))
                                (-> (last center)
                                    (+ radius)
                                    (* (Math/sin sum-angle)))]]
                     {:sum-angle (+ sum-angle cur)
                      :points (merge points point)}))
                 {:sum-angle angle
                  :points []})
         :points)))

(defn generate! [^Long seed]
  (let [avg-radius (rand/double-seeded seed 50.0 100.0)
        irregularity (rand/double-seeded seed 0.0 1.0)
        spikiness (rand/double-seeded seed 0.0 1.0)
        num-vertices (int (rand/double-seeded seed 3.0 100.0))]
    (generate-polygon seed [0 0] avg-radius irregularity spikiness num-vertices)))
