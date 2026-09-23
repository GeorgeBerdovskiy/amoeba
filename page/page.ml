module type S = sig 
  type t

  val create: int -> t
  val is_dirty: t -> bool
end

module Basic : S = struct
  type t = Bytes.t

  let create size = Bytes.create size
  let is_dirty _ = false
end