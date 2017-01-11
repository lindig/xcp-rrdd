(*
 * Copyright (C) Citrix Systems Inc.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published
 * by the Free Software Foundation; version 2.1 only. with the special
 * exception on linking described in file LICENSE.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Lesser General Public License for more details.
 *)

module Server=Rrd_idl.API(Idl.GenServer)

module X = struct
  (* This modules provides the functions from rrdd_server but without
   * labels. Labels are getting into the way when composing functions.
   * The labels where useful in the camlp4-style RPC but in PPX
   * we declare names explicitly and hence we don't need them. This
   * module could be removed by removing the labels and the redundant
   * first argument from the functions in the rrdd_server module.
   *)
  let has_vm_rrd vm_uuid =
    Rrdd_server.has_vm_rrd () ~vm_uuid

  let push_rrd_local vm_uuid domid =
    Rrdd_server.push_rrd_local () ~vm_uuid ~domid

  let push_rrd_remote vm_uuid remote_address =
    Rrdd_server.push_rrd_remote () ~vm_uuid ~remote_address

  let remove_rrd uuid =
    Rrdd_server.remove_rrd () ~uuid

  let migrate_rrd session_id remote_address vm_uuid host_uuid =
    Rrdd_server.migrate_rrd () ~session_id ~remote_address ~vm_uuid ~host_uuid

  let send_host_rrd_to_master master_address =
    Rrdd_server.send_host_rrd_to_master () ~master_address

  let backup_rrds remote_address unit =
    Rrdd_server.backup_rrds () ~remote_address unit

	let archive_rrd vm_uuid remote_address =
    Rrdd_server.archive_rrd () ~vm_uuid ~remote_address

	let archive_sr_rrd sr_uuid =
    Rrdd_server.archive_sr_rrd () ~sr_uuid

  let push_sr_rrd sr_uuid path =
    Rrdd_server.push_sr_rrd () ~sr_uuid ~path

  let add_host_ds ds_name =
    Rrdd_server.add_host_ds () ~ds_name

	let forget_host_ds ds_name =
    Rrdd_server.forget_host_ds () ~ds_name

	let query_possible_vm_dss vm_uuid =
    Rrdd_server.query_possible_vm_dss () ~vm_uuid

  let query_host_ds ds_name =
    Rrdd_server.query_host_ds () ~ds_name

	let add_vm_ds vm_uuid domid ds_name =
    Rrdd_server.add_vm_ds () ~vm_uuid ~domid ~ds_name

	let forget_vm_ds vm_uuid ds_name =
    Rrdd_server.forget_vm_ds () ~vm_uuid ~ds_name

	let query_vm_ds vm_uuid ds_name =
    Rrdd_server.query_vm_ds () ~vm_uuid ~ds_name

	let add_sr_ds sr_uuid ds_name =
    Rrdd_server.add_sr_ds () ~sr_uuid ~ds_name

  let forget_sr_ds sr_uuid ds_name =
    Rrdd_server.forget_sr_ds () ~sr_uuid ~ds_name

  let query_possible_sr_dss sr_uuid =
    Rrdd_server.query_possible_sr_dss () ~sr_uuid

  let query_sr_ds sr_uuid ds_name =
    Rrdd_server.query_sr_ds () ~sr_uuid ~ds_name

  let update_use_min_max value =
    Rrdd_server.update_use_min_max () ~value

  let update_vm_memory_target domid target =
    Rrdd_server.update_vm_memory_target () ~domid ~target

	let set_cache_sr sr_uuid =
    Rrdd_server.set_cache_sr () ~sr_uuid

  let unset_cache_sr unit =
    Rrdd_server.unset_cache_sr () unit

  module Plugin = struct
    let get_header unit =
      Rrdd_server.Plugin.get_header () unit

		let get_path uid =
      Rrdd_server.Plugin.get_path () ~uid

    let next_reading uid =
      Rrdd_server.Plugin.next_reading () ~uid

    let register uid frequency =
      Rrdd_server.Plugin.register () ~uid ~frequency

    let deregister uid =
      Rrdd_server.Plugin.deregister () ~uid

    module Local = struct
      let next_reading  uid =
        Rrdd_server.Plugin.Local.next_reading () ~uid

      let deregister uid =
        Rrdd_server.Plugin.Local.deregister () ~uid

      let register uid info protocol =
        Rrdd_server.Plugin.Local.register () ~uid ~info ~protocol
    end

    module Interdomain = struct
      let register uid info protocol =
        Rrdd_server.Plugin.Interdomain.register () ~uid ~info ~protocol

      let deregister uid =
        Rrdd_server.Plugin.Interdomain.deregister () ~uid

      let next_reading uid =
        Rrdd_server.Plugin.Interdomain.next_reading () ~uid
    end

  end

  module HA = struct
    let enable_and_update statefile_latencies heartbeat_latency xapi_latency =
      Rrdd_server.HA.enable_and_update ()
        ~statefile_latencies ~heartbeat_latency ~xapi_latency

    let disable unit =
      Rrdd_server.HA.disable () unit
  end

  module Deprecated = struct
		let load_rrd uuid timescale master_address =
      Rrdd_server.Deprecated.load_rrd () ~uuid ~timescale ~master_address
  end
end

let (>>=)     = Rresult.R.bind
let ok        = Rresult.R.ok

(* TODO add exception handling *)
let lift1 f x1                  = ok (f x1)
let lift2 f x1 x2               = ok (f x1 x2)
let lift3 f x1 x2 x3            = ok (f x1 x2 x3)
let lift4 f x1 x2 x3 x4         = ok (f x1 x2 x3 x4)

let process =
  Idl.GenServer.empty ()
  |> Server.has_vm_rrd              (lift1 X.has_vm_rrd)
  |> Server.push_rrd_local          (lift2 X.push_rrd_local)
  |> Server.push_rrd_remote         (lift2 X.push_rrd_remote)
  |> Server.remove_rrd              (lift1 X.remove_rrd)
  |> Server.migrate_rrd             (lift4 X.migrate_rrd)
  |> Server.send_host_rrd_to_master (lift1 X.send_host_rrd_to_master)
  |> Server.backup_rrds             (lift2 X.backup_rrds)
  |> Server.archive_rrd             (lift2 X.archive_rrd)
  |> Server.archive_sr_rrd          (lift1 X.archive_sr_rrd)
  |> Server.push_sr_rrd             (lift2 X.push_sr_rrd)
  |> Server.add_host_ds             (lift1 X.add_host_ds)
  |> Server.forget_host_ds          (lift1 X.forget_host_ds)
  |> Server.query_possible_vm_dss   (lift1 X.query_possible_vm_dss)
  |> Server.query_host_ds           (lift1 X.query_host_ds)
  |> Server.add_vm_ds               (lift3 X.add_vm_ds)
  |> Server.forget_vm_ds            (lift2 X.forget_vm_ds)
  |> Server.query_vm_ds             (lift2 X.query_vm_ds)
  |> Server.add_sr_ds               (lift2 X.add_sr_ds)
  |> Server.forget_sr_ds            (lift2 X.forget_sr_ds)
  |> Server.query_possible_sr_dss   (lift1 X.query_possible_sr_dss)
  |> Server.query_sr_ds             (lift2 X.query_sr_ds)
  |> Server.update_use_min_max      (lift1 X.update_use_min_max)
  |> Server.update_vm_memory_target (lift2 X.update_vm_memory_target)
  |> Server.set_cache_sr            (lift1 X.set_cache_sr)
  |> Server.unset_cache_sr          (lift1 X.unset_cache_sr)
  |> Server.Plugin.get_header       (lift1 X.Plugin.get_header)
  |> Server.Plugin.get_path         (lift1 X.Plugin.get_path)
  |> Server.Plugin.register         (lift2 X.Plugin.register)
  |> Server.Plugin.deregister       (lift1 X.Plugin.deregister)
  |> Server.Plugin.next_reading     (lift1 X.Plugin.next_reading)
  |> Server.Plugin.Local.register           (lift3 X.Plugin.Local.register)
  |> Server.Plugin.Local.deregister         (lift1 X.Plugin.Local.deregister)
  |> Server.Plugin.Local.next_reading       (lift1 X.Plugin.Local.next_reading)
  |> Server.Plugin.Interdomain.register     (lift3 X.Plugin.Interdomain.register)
  |> Server.Plugin.Interdomain.deregister   (lift1 X.Plugin.Interdomain.deregister)
  |> Server.Plugin.Interdomain.next_reading (lift1 X.Plugin.Interdomain.next_reading)
  |> Server.HA.enable_and_update    (lift3 X.HA.enable_and_update)
  |> Server.HA.disable              (lift1 X.HA.disable)
  |> Server.Deprecated.load_rrd     (lift3 X.Deprecated.load_rrd)
  |> Idl.GenServer.server



