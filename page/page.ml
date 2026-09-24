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

  (* How many bytes does a field communicating offset take? *)
  let offset_field_size = 2
  let create size = Bytes.create size
  let is_dirty _ = false

  (* Byte offset of the next available slot. *)
  let slot_end_offset page = Bytes.get_uint16_ne page 0

  (* Byte offset of the last inserted record.  *)
  let record_start_offset page = Bytes.get_uint16_ne page 2

  (* How many bytes of space are available for records *)
  let available_space page =
    record_start_offset page - slot_end_offset page - offset_field_size

  let reserve page size =
    if available_space page >= size then
      let new_slot_offset = slot_end_offset page + 2 in
      let new_record_offset = record_start_offset page - size in
      let _ = Bytes.set_int16_ne page 0 new_slot_offset in
      let _ = Bytes.set_int16_ne page 2 new_record_offset in
      Some (new_slot_offset, new_record_offset)
    else None

  let insert page record =
    let record_size = R.size record in
    match reserve page record_size with
    | Some (slot, offset) ->
        let _ = Bytes.blit (R.to_bytes record) 0 page offset record_size in
        Some slot
    | None -> None

  let get _ = None
end
