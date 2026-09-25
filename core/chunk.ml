type t = Bytes.t

let make size v = Bytes.make size v
let get_u8 chunk at = Bytes.get_uint8 chunk at
let get_u16 chunk at = Bytes.get_uint16_le chunk at
let set_u8 chunk at v = Bytes.set_uint8 chunk at v
let set_u16 chunk at v = Bytes.set_uint16_le chunk at v
let to_bytes chunk = chunk
