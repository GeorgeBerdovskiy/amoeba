module type S = sig
  type t
  type key
  type rid

  val create: unit -> t
  val lookup: t -> key -> rid list
end
