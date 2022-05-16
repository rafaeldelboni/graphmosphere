(ns graphmosphere.percent-encode
  (:require [clojure.string :as string]))

(set! *warn-on-reflection* true)

(def ^:private reserved-characters-regex #"[ !#$%&'()*+,/:;=?@\[\]]")

(defn ^:private char->percent-encode
  "Percent-encoding a reserved character involves converting the character to its
  corresponding byte value in ASCII and then representing that value as a pair of
  hexadecimal digits. The digits, preceded by a percent sign (%) which is used as
  an escape character, are then used in the URI in place of the reserved character."
  [char]
  (case char
    " " "%20"
    "!" "%21"
    "#" "%23"
    "$" "%24"
    "%" "%25"
    "&" "%26"
    "'" "%27"
    "(" "%28"
    ")" "%29"
    "*" "%2A"
    "+" "%2B"
    "," "%2C"
    "/" "%2F"
    ":" "%3A"
    ";" "%3B"
    "=" "%3D"
    "?" "%3F"
    "@" "%40"
    "[" "%5B"
    "]" "%5D"
    char))

(defn str->encode
  "Percent-encoding, also known as URL encoding, is a method to encode arbitrary
  data in a Uniform Resource Identifier (URI) using only the limited US-ASCII
  characters legal within a URI."
  [str]
  (string/replace str reserved-characters-regex char->percent-encode))
