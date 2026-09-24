module type S = sig
  type t
  type record
  type slot

  val create : int -> t
  val is_dirty : t -> bool
  val insert : t -> record -> slot option
  val get : slot -> record option
end

module Basic (R : Record.S) : S with type record = R.t = struct
  type t = Bytes.t
  type record = R.t
  type slot = int

  let create size = Bytes.create size
  let is_dirty _ = false

  let insert page record =
    let slot_end = Bytes.get_uint16_ne page 0 in
    let record_start = Bytes.get_uint16_ne page 2 in
    let space = record_start - slot_end - 16 in
    let record_size = R.size record in
    if record_size > space then None
    else
      let offset = record_start - record_size in
      let _ = Bytes.blit (R.to_bytes record) 0 page offset record_size in
      let _ = Bytes.set_int16_ne page slot_end offset in
      let _ = Bytes.set_int16_ne page 0 (slot_end + 16) in
      let _ = Bytes.set_int16_ne page 2 offset in
      Some slot_end

  let get _ = None
end
