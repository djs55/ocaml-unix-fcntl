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

  match Filename.basename !filename with
  | "unix_fcntl_types_detect.c" ->
    let type_oc = open_out !filename in
    let fmt = Format.formatter_of_out_channel type_oc in
    Format.fprintf fmt "#ifndef __FreeBSD__@.";
    Format.fprintf fmt "#  define _GNU_SOURCE@.";
    Format.fprintf fmt "#  define _POSIX_C_SOURCE 200809L@.";
    Format.fprintf fmt "#  define _DARWIN_C_SOURCE@.";
    Format.fprintf fmt "#endif@.";
    Format.fprintf fmt "#include <fcntl.h>@.";
    Cstubs.Types.write_c fmt (module Unix_fcntl_types.C);
    close_out type_oc
  | x ->
    Printf.fprintf stderr "Unknown output filename. Try unix_fcntl_types_detect.c\n";
    exit(-1)
