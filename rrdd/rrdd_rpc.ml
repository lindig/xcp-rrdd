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

module Server=Rrd_idl.API(Idl.GenServerExn)

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

let process =
  Idl.GenServer.empty ()
  |> Server.has_vm_rrd                  X.has_vm_rrd
  |> Server.push_rrd_local              X.push_rrd_local
  |> Server.push_rrd_remote             X.push_rrd_remote
  |> Server.remove_rrd                  X.remove_rrd
  |> Server.migrate_rrd                 X.migrate_rrd
  |> Server.send_host_rrd_to_master     X.send_host_rrd_to_master
  |> Server.backup_rrds                 X.backup_rrds
  |> Server.archive_rrd                 X.archive_rrd
  |> Server.archive_sr_rrd              X.archive_sr_rrd
  |> Server.push_sr_rrd                 X.push_sr_rrd
  |> Server.add_host_ds                 X.add_host_ds
  |> Server.forget_host_ds              X.forget_host_ds
  |> Server.query_possible_vm_dss       X.query_possible_vm_dss
  |> Server.query_host_ds               X.query_host_ds
  |> Server.add_vm_ds                   X.add_vm_ds
  |> Server.forget_vm_ds                X.forget_vm_ds
  |> Server.query_vm_ds                 X.query_vm_ds
  |> Server.add_sr_ds                   X.add_sr_ds
  |> Server.forget_sr_ds                X.forget_sr_ds
  |> Server.query_possible_sr_dss       X.query_possible_sr_dss
  |> Server.query_sr_ds                 X.query_sr_ds
  |> Server.update_use_min_max          X.update_use_min_max
  |> Server.update_vm_memory_target     X.update_vm_memory_target
  |> Server.set_cache_sr                X.set_cache_sr
  |> Server.unset_cache_sr              X.unset_cache_sr
  |> Server.Plugin.get_header           X.Plugin.get_header
  |> Server.Plugin.get_path             X.Plugin.get_path
  |> Server.Plugin.register             X.Plugin.register
  |> Server.Plugin.deregister           X.Plugin.deregister
  |> Server.Plugin.next_reading         X.Plugin.next_reading
  |> Server.Plugin.Local.register       X.Plugin.Local.register
  |> Server.Plugin.Local.deregister     X.Plugin.Local.deregister
  |> Server.Plugin.Local.next_reading   X.Plugin.Local.next_reading
  |> Server.Plugin.Interdomain.register X.Plugin.Interdomain.register
  |> Server.Plugin.Interdomain.deregister   X.Plugin.Interdomain.deregister
  |> Server.Plugin.Interdomain.next_reading X.Plugin.Interdomain.next_reading
  |> Server.HA.enable_and_update        X.HA.enable_and_update
  |> Server.HA.disable                  X.HA.disable
  |> Server.Deprecated.load_rrd         X.Deprecated.load_rrd
  |> Idl.GenServer.server



