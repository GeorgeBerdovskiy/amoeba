module type S = sig
  type page
  type t

  val create : int -> t
  val get : t -> int64 -> page option
end

module Basic (P : Page.S) : S with type page = P.t = struct
  type page = P.t
  type t = page option array

  let create size = Array.make size None
  let get _ _ = None
end
