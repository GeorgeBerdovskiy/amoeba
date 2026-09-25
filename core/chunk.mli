type t

val make : int -> char -> t
val get_u8 : t -> int -> int
val get_u16 : t -> int -> int
val set_u8 : t -> int -> int -> unit
val set_u16 : t -> int -> int -> unit
val to_bytes : t -> Bytes.t
