module type S = sig
  type t
  type id

  val to_bytes : t -> Bytes.t
  val size : t -> int
end

module Basic : S = struct
  type t = bytes list
  type id = int64

  let to_bytes page = Bytes.concat Bytes.empty page
  let size page = Bytes.length (to_bytes page)
end
