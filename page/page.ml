module type S = sig
  type t
  type record
  type slot

  val create : int -> t
  val is_dirty : t -> bool
  val insert : t -> record -> slot option
  val get : slot -> record option
end

(** Slotted page, native endian.

    {v
      0            2              4           5
      +------------+--------------+-----------+------+------+-------------+
      | slot_end   | record_start | dirty_bit | slot | slot | → ← records |
      | u16        | u16          | u8        | u16  | u16  |             |
      +------------+--------------+-----------+------+------+-------------+
    v}

    Field [slot_end] is the next free slot. Field [record_start] is the bottom
    of the record region. *)
module Basic (R : Record.S) : S with type record = R.t = struct
  module Chunk = Core.Chunk

  type t = Chunk.t
  type record = R.t
  type slot = int

  let u16 = 2 (* Bytes *)
  let u8 = 1 (* Bytes *)
  let slot_end_at = 0
  let record_start_at = u16
  let dirty_bit_at = u16 + u16
  let header_size = u16 + u16 + u8
  let is_dirty page = Chunk.get_u8 page dirty_bit_at != 0

  let create size =
    let page = Chunk.make size '\000' in
    Chunk.set_u16 page slot_end_at header_size;
    Chunk.set_u16 page record_start_at size;
    Chunk.set_u8 page dirty_bit_at 1;
    page

  let slot_end page = Chunk.get_u16 page slot_end_at
  let record_start page = Chunk.get_u16 page record_start_at

  (* How many bytes of space are available for records? *)
  let available_space page = record_start page - slot_end page - u16

  (** Try to reserve a chunk of [size] bytes for a record. *)
  let reserve page size =
    if available_space page < size then None
    else
      let slot_at = slot_end page in
      let record_at = record_start page - size in
      Chunk.set_u16 page slot_end_at (slot_at + u16);
      Chunk.set_u16 page record_start_at record_at;
      Some (slot_at, record_at)

  (** Try to insert a [record] into the [page]. Returns the chosen slot, or
      [None] if the page has insufficient space. *)
  let insert page record =
    let n = R.size record in
    match reserve page n with
    | None -> None
    | Some (slot_at, record_at) ->
        Chunk.set_u16 page slot_at record_at;
        Chunk.set_u8 page dirty_bit_at 1;
        Bytes.blit (R.to_bytes record) 0 (Chunk.to_bytes page) record_at n;
        Some slot_at

  let get _ = None
end
