module type S = sig 
  type t

  val create: unit -> t
  val is_dirty: t -> bool
end

module Basic : S = struct
  type t = string

  let create () = ""
  let is_dirty _ = false
end