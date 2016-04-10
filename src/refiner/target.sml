structure Target : TARGET =
struct
  open RefinerKit

  infix 4 >>
  infix 3 |>

  datatype target =
      TARGET_HYP of symbol
    | TARGET_CONCL

  type judgment = Lcf.J.judgment

  fun mapConcl f =
    fn TRUE (p, tau) => TRUE (f p, tau)
     | TYPE (p, tau) => TYPE (f p, tau)

  fun targetRewrite f target (goal as (G |> H >> concl)) =
    case target of
        TARGET_HYP sym =>
          let
            val hyps = #hypctx H
            val hyps' = SymbolTelescope.modify sym (fn (x, tau) => (f x, tau)) hyps
            val H' =
              {metactx = #metactx H,
               symctx = #symctx H,
               hypctx = hyps'}
          in
            G |> H' >> concl
          end
      | TARGET_CONCL => G |> H >> mapConcl f concl
end
