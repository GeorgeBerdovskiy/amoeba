module type S = sig
  type t
  type key
  type tuple

  val get : t -> key -> tuple option
end
