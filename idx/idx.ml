module type S = sig
  type t
  type key
  type rid

  val create: unit -> t
  val lookup: t -> key -> rid list
end

module Basic : S = struct
  module M = Map.Make(Int)

  type key = int
  type rid = int * int
  type t = rid list M.t

  let create () = M.empty

  let lookup t key =
    match M.find_opt key t with
    | None -> []
    | Some rids -> rids
end