
require ('Node')
require ('NetIF')

local argparse = require "argparse"
-- parse command line arguments
local parser = argparse("runNode", "Run measurement node")

parser:option ("-n --name", "Node Name" )
parser:option ("--ctrl_if", "RPC Interface of Control node" )

parser:option ("--log_ip", "IP of Logging node" )

parser:option ("-P --port", "Control RPC port", "12346" )
parser:option ("-L --log_port", "Logging RPC port", "12347" )
parser:option ("--retries", "number of retries for rpc and wifi connections", "10" )
parser:option ("-d --dump_to_dir", "Dump collected traces to local directory" )

local args = parser:parse ()

local ctrl = NetIF:create ( args.ctrl_if )
local node = Node:create ( args.name, arg[-1] or "/usr/bin/lua", ctrl, args.port, args.log_port, args.log_ip
                         , args.retries, args.dump_to_dir )
if ( node == nil ) then
    print ( "Error: node not started" )
    od.exit (1)
end

function set_channel_htmode ( ... ) return node:set_channel_htmode ( ... ) end

function get_ctrl_addr ( ... ) return node:get_ctrl_addr ( ... ) end

function get_board ( ... ) return node:get_board ( ... ) end
function get_os_release ( ... ) return node:get_os_release ( ... ) end

function phy_devices ( ... ) return node:phy_devices ( ... ) end
function enable_wifi ( ... ) return node:enable_wifi ( ... ) end
function restart_wifi( ... ) return node:restart_wifi( ... ) end

function get_iw_info ( ... ) return node:get_iw_info ( ... ) end
function get_iw_link ( ... ) return node:get_iw_link ( ... ) end
function get_ssid (...) return node:get_ssid(...) end
-- move to netif, to emerge node.wifi:stations and node.wifi2:stations for multi chip systems
function visible_stations(...) return node:visible_stations(...) end
function set_ani (...) return node:set_ani (...) end
function set_ldpc (...) return node:set_ldpc (...) end

function link_to_ssid ( ... ) return node:link_to_ssid ( ... ) end
function get_linked_ssid(...) return node:get_linked_ssid(...) end
function get_linked_iface(...) return node:get_linked_iface(...) end
function get_linked_mac(...) return node:get_linked_mac(...) end
function get_linked_signal(...) return node:get_linked_signal(...) end
function get_linked_rate_idx(...) return node:get_linked_rate_idx(...) end

function get_iface(...) return node:get_iface(...) end
function get_mac(...) return node:get_mac(...) end
function get_addr(...) return node:get_addr(...) end
function get_mon(...) return node:get_mon(...) end
function has_lease(...) return node:has_lease(...) end

function tx_rate_indices(...) return node:tx_rate_indices(...) end
function tx_rate_names(...) return node:tx_rate_names(...) end
function tx_power_indices(...) return node:tx_power_indices(...) end

function set_tx_rate(...) return node:set_tx_rate(...) end
function get_tx_rate(...) return node:get_tx_rate(...) end
function set_tx_power(...) return node:set_tx_power(...) end
function get_tx_power(...) return node:get_tx_power(...) end

function set_global_tx_rate(...) return node:set_global_tx_rate(...) end
function get_global_tx_rate(...) return node:get_global_tx_rate(...) end
function set_global_tx_power(...) return node:set_global_tx_power(...) end
function get_global_tx_power(...) return node:get_global_tx_power(...) end

-- cpuage
function start_cpusage ( ... ) return node:start_cpusage ( ... ) end
function get_cpusage ( ... ) return node:get_cpusage ( ... ) end
function stop_cpusage ( ... ) return node:stop_cpusage ( ... ) end
function cleanup_cpusage ( ... ) return node:cleanup_cpusage ( ... ) end

-- move to netif, to emerge node.wifi:stations and node.wifi2:stations for multi chip systems
function add_monitor(...) return node:add_monitor(...) end
function remove_monitor(...) return node:remove_monitor(...) end
function set_tx_power ( ... ) return node:set_tx_power ( ... ) end -- AP only
function set_tx_rate ( ... ) return node:set_tx_rate ( ... ) end -- AP only

-- global stats
function get_dmesg ( ... ) return node:get_dmesg ( ... ) end

-- rc_stats
function start_rc_stats(...) return node:start_rc_stats(...) end
function get_rc_stats(...) return node:get_rc_stats(...) end
function stop_rc_stats(...) return node:stop_rc_stats(...) end
function cleanup_rc_stats ( ... ) return node:cleanup_rc_stats ( ... ) end

-- regmon
function start_regmon_stats(...) return node:start_regmon_stats(...) end
function get_regmon_stats(...) return node:get_regmon_stats(...) end
function stop_regmon_stats(...) return node:stop_regmon_stats(...) end
function cleanup_regmon ( ... ) return node:cleanup_regmon ( ... ) end

-- tcpdump
function start_tcpdump ( ... ) return node:start_tcpdump ( ... ) end
function get_tcpdump ( ... ) return node:get_tcpdump ( ... ) end
function stop_tcpdump ( ... ) return node:stop_tcpdump ( ... ) end
function cleanup_tcpdump ( ... ) return node:cleanup_tcpdump ( ... ) end

-- tcp iperf
function start_tcp_iperf_s (...) return node:start_tcp_iperf_s(...) end
function run_tcp_iperf(...) return node:run_tcp_iperf(...) end

-- udp iperf
function start_udp_iperf_s(...) return node:start_udp_iperf_s(...) end
function run_udp_iperf(...) return node:run_udp_iperf(...) end
function run_multicast(...) return node:run_multicast(...) end
function wait_iperf_c(...) return node:wait_iperf_c(...) end

-- udp / tcp iperf
function stop_iperf_server(...) return node:stop_iperf_server(...) end

function is_pid_running ( ... ) return node:is_pid_running ( ... ) end
function get_pid(...) return node:get_pid(...) end
function get_free_mem ( ... ) return node:get_free_mem ( ... ) end
function set_timezone ( ... ) return node:set_timezone ( ... ) end
function set_date(...) return node:set_date(...) end
function set_nameserver (...) return node:set_nameserver (...) end
function check_bridge (...) return node:check_bridge (...) end

print ( node )
print ( node:run ( args.port ) )
