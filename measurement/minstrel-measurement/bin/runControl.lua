
-- The script starts a measurement control node 

require ('ControlNode')
local argparse = require ('argparse')

local parser = argparse ( "runControl", "Run mintrel measurement control node." )
 
parser:option ("--ctrl_if", "Control Interface name", "eth0" )
parser:option ("-C --port", "RPC port", "12346" )

parser:option ("--log_ip", "IP of Logging node" )
parser:option ("--log_file", "Logging file name", "minstrelm.log" )
parser:option ("-L --log_port", "Logging port", "12347" )
parser:flag ("--enable_fixed", "enable fixed setting of parameters", false)
parser:option ("--retries", "number of retries for rpc and wifi connections", "10" )
parser:flag ("--online", "fetch data online when possible", false )

parser:option ("-O --output", "measurement / analyse data directory", "/tmp")

local args = parser:parse ()

local net = NetIF:create ( args.ctrl_if )
local node = ControlNode:create ( "Control", net, args.port, args.log_port, args.log_ip
                                , args.output, args.retries, args.online )

function __tostring ( ... ) return node:__tostring ( ... ) end

function hosts_known ( ... ) return node:hosts_known ( ... ) end

function get_board ( ... ) return node:get_board ( ... ) end
function get_boards ( ... ) return node:get_boards ( ... ) end

function get_os_release ( ... ) return node:get_os_release ( ... ) end
function get_os_releases ( ... ) return node:get_os_releases ( ... ) end

function add_ap ( ... ) return node:add_ap ( ... ) end
function add_sta ( ... ) return node:add_sta ( ... ) end
function add_mesh_node ( ... ) return node:add_mesh_node ( ... ) end

function reachable ( ... ) return node:reachable ( ... ) end

function start_nodes ( ... ) return node:start_nodes ( ... ) end
function stop ( ... ) return node:stop ( ... ) end

function connect_nodes ( ... ) return node:connect_nodes ( ... ) end
function disconnect_nodes ( ... ) return node:disconnect_nodes ( ... ) end

function init_experiments ( ... ) return node:init_experiments ( ... ) end
function get_keys ( ... ) return node:get_keys ( ... ) end

function get_channel ( ... ) return node:get_channel ( ... ) end
function get_htmode ( ... ) return node:get_htmode ( ... ) end

function get_txpowers ( ... ) return node:get_txpowers ( ... ) end
function get_txrates ( ... ) return node:get_txrates ( ... ) end

--function run_experiment ( ... ) return node:run_experiment ( ... ) end
function init_experiment ( ... ) return node:init_experiment ( ... ) end
function exp_has_data ( ... ) return node:exp_has_data ( ... ) end
function exp_next_data ( ... ) return node:exp_next_data ( ... ) end
function finish_experiment ( ... ) return node:finish_experiment ( ... ) end

function get_tcpdump_pcap ( ... ) return node:get_tcpdump_pcap ( ... ) end
function get_tcpdump_size ( ... ) return node:get_tcpdump_size ( ... ) end
function get_rc_stats ( ... ) return node:get_rc_stats ( ... ) end
function get_cpusage_stats ( ... ) return node:get_cpusage_stats ( ... ) end
function get_regmon_stats ( ... ) return node:get_regmon_stats ( ... ) end
function get_iperf_s_out ( ... ) return node:get_iperf_s_out ( ... ) end
function get_iperf_c_out ( ... ) return node:get_iperf_c_out ( ... ) end
function get_dmesg ( ... ) return node:get_dmesg ( ... ) end

function set_date ( ... ) return node:set_date ( ... ) end
function set_dates ( ... ) return node:set_dates ( ... ) end
function get_pid ( ... ) return node:get_pid ( ... ) end
function kill ( ... ) return node:kill ( ... ) end

function randomize_nodes ( ... ) return node:randomize_nodes ( ... ) end
function list_nodes ( ... ) return node:list_nodes ( ... ) end
function get_mac ( ... ) return node:get_mac ( ... ) end
function get_mac_br ( ... ) return node:get_mac_br ( ... ) end
function get_opposite_macs ( ... ) return node:get_opposite_macs ( ... ) end
function get_opposite_macs_br ( ... ) return node:get_opposite_macs_br ( ... ) end
function list_aps ( ... ) return node:list_aps ( ... ) end
function list_stas ( ... ) return node:list_stas ( ... ) end
function list_phys ( ... ) return node:list_phys ( ... ) end
function set_phy ( ... ) return node:set_phy ( ... ) end
function get_phy ( ... ) return node:get_phy ( ... ) end
function enable_wifi ( ... ) return node:enable_wifi ( ... ) end
function link_to_ssid ( ... ) return node:link_to_ssid ( ... ) end
function get_ssid ( ... ) return node:get_ssid ( ... ) end
function add_station ( ... ) return node:add_station ( ... ) end
function list_stations ( ... ) return node:list_stations ( ... ) end

function set_ani ( ... ) return node:set_ani ( ... ) end
function set_ldpc ( ... ) return node:set_ldpc ( ... ) end
function set_nameserver (...) return node:set_nameserver (...) end
function set_nameservers (...) return node:set_nameservers (...) end
function check_bridges (...) return node:check_bridges (...) end

-- make all functions available via RPC
print ( node:__tostring() )
print ( node:run () )
