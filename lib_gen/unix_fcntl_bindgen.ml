(*
 * Copyright (c) 2015 David Sheets <sheets@alum.mit.edu>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 *
 *)

open Ctypes

let () =
  let filename = ref "" in
  Arg.parse [
    "-o", Arg.Set_string filename, "output file name"
  ] (fun x ->
    Printf.fprintf stderr "Unknown argument: %s\n" x;
    exit (-1)
  ) "Generate some bindings";
  let prefix = "caml_" in
  match Filename.basename !filename with
  | "unix_fcntl_stubs.c" ->
    let stubs_oc = open_out !filename in
    let fmt = Format.formatter_of_out_channel stubs_oc in
    Format.fprintf fmt "#include <fcntl.h>@.";
    Format.fprintf fmt "#include \"unix_fcntl_util.h\"@.";
    Cstubs.write_c fmt ~prefix (module Unix_fcntl_bindings.C);
    close_out stubs_oc
  | "unix_fcntl_generated.ml" ->
    let generated_oc = open_out !filename in
    let fmt = Format.formatter_of_out_channel generated_oc in
    Cstubs.write_ml fmt ~prefix (module Unix_fcntl_bindings.C);
    close_out generated_oc
  | x ->
    Printf.fprintf stderr "Unknown output filename. Try unix_fcntl_stubs.c or unix_fcntl_generated.ml\n";
    exit(-1)
