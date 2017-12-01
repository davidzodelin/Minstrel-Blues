-- Base class for experiments
-- and no operation experiment

require ('parsers/proc_pid_stat')

Experiment = { control = nil
             , runs = nil
             , tx_powers = nil
             , tx_rates = nil
             , tcpdata = nil
             , is_fixed = nil
             , pids = nil
             }


function Experiment:new (o)
    local o = o or {}
    setmetatable(o, self)
    self.__index = self
    o.pids = {}
    return o
end

-- returns whether all registered pids are still running
function Experiment:is_running ()
    -- note: for all exited use running |= value
    if ( self.pids ~= nil ) then
        local running = {}
        for i, pid in ipairs ( self.pids ) do
            running [ i ] = false
        end
        for i, pid in ipairs ( self.pids ) do
            local file = io:open ("/proc/" .. tostring ( self.pid ) .. "/stat" )
            if ( file ~= nil ) then
                local contents = file:read ( "*a" )
                if ( contents ~= nil ) then
                    local exp_stat = parse_proc_pid_stat ( content )
                    if ( exp_stat ~= nil ) then
                        running [ i ] = exp_stat.state == "S" or exp_stat.state == "R"
                        -- state ~= "Z"
                    else
                        running [ i ] = false
                    end
                end
            else
                running [ i ] = false
            end
        end
        return Misc.all_true ( running )
    else
        return false
    end
end

function Experiment:keys ( ap_ref )
    local keys = {}
    return keys
end

function Experiment:get_rate ( key )
    if ( key ~= nil ) then
        local keys = split ( key, "-" )
        if ( keys ~= nil and table_size ( keys ) > 0 ) then
            return tonumber ( keys [ 1 ] )
        end
    end
    return nil
end

function Experiment:get_power ( key )
    if ( key ~= nil ) then
        local keys = split ( key, "-" )
        if ( keys ~= nil and table_size ( keys ) > 1 ) then
            return tonumber ( keys [ 2 ] )
        end
    end
    return nil
end

-- keys are '-' sepearted strings beginning with the rate and the power index followed by
-- user defined indices and finish by the iteration index
-- i.e. 1-0-1 splits into: rate=1 and power=0, runs=1
-- note: obviously these are real indices, siince encoding of negative values are not possible with
-- this type of keys
function Experiment:keys ( ap_ref )
end

function Experiment:prepare_measurement ( ap_ref, online )
    ap_ref:create_measurement ( online )
    ap_ref.stats:enable_rc_stats ( ap_ref.stations )
end

function Experiment:settle_measurement ( ap_ref, key )
    ap_ref:restart_wifi ()
    local visible = ap_ref:wait_station ()
    self.control:send_debug ( "visible: " .. tostring ( visible ) )
    local linked = false
    if ( visible == true ) then
        linked = ap_ref:wait_linked ()
    end
    self.control:send_debug ( "linked: " .. tostring ( linked ) )
    ap_ref:add_monitor ()
    if ( self.is_fixed == true and linked and visible ) then
        for _, station in ipairs ( ap_ref.stations ) do
            local tx_rate = self:get_rate ( key )
            ap_ref.rpc.set_tx_rate ( ap_ref.wifi_cur, station, tx_rate )
            local tx_rate_new = ap_ref.rpc.get_tx_rate ( ap_ref.wifi_cur, station )
            if ( tx_rate_new ~= tx_rate ) then
                self.control:send_error ( "rate not set correctly: should be " .. tx_rate 
                                          .. " (set) but is " .. ( tx_rate_new or "unset" ) .. " (actual)" )
            end
            local tx_power = self:get_power ( key )
            ap_ref.rpc.set_tx_power ( ap_ref.wifi_cur, station, tx_power )
            local tx_power_new = ap_ref.rpc.get_tx_power ( ap_ref.wifi_cur, station )
            if ( tx_power_new ~= tx_power ) then
                self.control:send_error ( "tx power not set correctly: should be " .. tx_power 
                                          .. " (set) but is " .. ( tx_power_new or "unset" ) .. " (actual)" )
            end
        end
    end
    return (linked and visible)
end

function Experiment:start_measurement ( ap_ref, key )
end

function Experiment:stop_measurement ( ap_ref, key )
    ap_ref:stop_measurement ( key )
end

function Experiment:fetch_measurement ( ap_ref, key )
    return ap_ref:fetch_measurement ( key )
end

function Experiment:unsettle_measurement ( ap_ref, key )
    ap_ref:remove_monitor ()
end

function Experiment:start_experiment ( ap_ref, key )
    self.control:send_debug("start_experiment not implemented")
end

function Experiment:wait_experiment ( ap_ref )
    self.control:send_debug("wait_experiment not implemented")
end
