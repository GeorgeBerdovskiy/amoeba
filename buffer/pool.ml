module type S = sig
  type page
  type t

  val create : unit -> t
  val get : t -> int64 -> page option
end

module Make (P: Page.S) : S with type page = P.t = struct
  type page = P.t
  type t = string

  let create () = ""
  let get _ _ = None
end