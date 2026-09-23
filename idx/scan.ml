module type S = sig
  type t
  type predicate
  type rid
  type idx
  type bp

  val find : predicate -> rid list
end
