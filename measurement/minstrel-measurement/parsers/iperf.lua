require ('parsers/parsers')
local pprint = require ('pprint')

-- iperf2 server / client output parse
-- note: iperf3 has --json flag for json output
-- TODO: test with multiple clients
-- TODO: test with tcp
-- TODO: implement client (multicast has no server running)
-- TODO: parser for full output instead of single line

IperfClient = { id = nil
              , interval_start = nil
              , interval_end = nil
              , transfer = nil
              , transfer_unit = nil
              , bandwidth = nil
              , bandwidth_unit = nil
              , jitter = nil
              , lost_datagrams = nil
              , total_datagrams = nil
              , percent = nil
              }

function IperfClient:new (o)
    local o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function IperfClient:create ()
    local o = IperfClient:new()
    return o
end

function IperfClient:__tostring() 
    return "IperfClient id: " .. ( self.id or "unset" )
            .. " interval_start: " .. ( self.interval_start or "unset" )
            .. " interval_end: " .. ( self.interval_end or "unset" )
            .. " transfer: " .. ( self.transfer or "unset" )
            .. " transfer_unit: " .. ( self.transfer_unit or "unset" )
            .. " bandwidth: " .. ( self.bandwidth or "unset" )
            .. " bandwidth_unit: " .. ( self.bandwidth_unit or "unset" )
            .. " jitter: " .. ( self.jitter or "unset" )
            .. " lost_datagrams: " .. ( self.lost_datagrams or "unset" )
            .. " total_datagrams: " .. ( self.total_datagrams or "unset" )
            .. " percent: " .. ( self.percent or "unset" )
end

function parse_iperf_client ( iperf )

    local out = IperfClient:create()

    if ( iperf == nil ) then return out end
    if ( string.len ( iperf ) == 0 ) then return out end

    local rest = iperf
    local state = true

    state, rest = parse_str ( rest, "------------------------------------------------------------" )
    if ( state == true ) then return out end

    state, rest = parse_str ( rest, "Client connecting to" )
    if ( state == true ) then return out end

    state, rest = parse_str ( rest, "Sending" )
    if ( state == true ) then return out end

    state, rest = parse_str ( rest, "UDP buffer size:" )
    if ( state == true ) then return out end

    local id = nil
    local interval_start = nil
    local interval_end = nil
    local transfer = nil
    local transfer_unit = nil
    local bandwidth = nil
    local bandwidth_unit = nil
    local jitter = nil
    local lost_datagrams = nil
    local total_datagrams = nil
    local percent = nil

    state, rest = parse_str ( rest, "[" )
    rest = skip_layout ( rest )

    state, rest = parse_str ( rest, "ID" )
    if ( state == true ) then return out end

    id, rest = parse_num ( rest )
    state, rest = parse_str ( rest, "]" )
    rest = skip_layout ( rest )

    state, rest = parse_str ( rest, "local" )
    if ( state == true ) then return out end

    state, rest = parse_str ( rest, "Sent" )
    if ( state == true ) then return out end

    state, rest = parse_str ( rest, "Server Report:" )
    if ( state == true ) then return out end

    interval_start, rest = parse_real ( rest )
    state, rest = parse_str ( rest, "-" )
    rest = skip_layout ( rest )
    interval_end, rest = parse_real ( rest )
    rest = skip_layout ( rest )
    state, rest = parse_str ( rest, "sec" )
    rest = skip_layout ( rest )

    transfer, rest = parse_real ( rest )
    rest = skip_layout ( rest )

    transfer_unit, rest = parse_ide ( rest )
    rest = skip_layout ( rest )

    local add_chars = { "/" }
    bandwidth, rest = parse_real ( rest )
    rest = skip_layout ( rest )
    bandwidth_unit, rest = parse_ide ( rest, add_chars )
    rest = skip_layout ( rest )

    if ( rest ~= "" ) then
        jitter, rest = parse_real ( rest )
        rest = skip_layout ( rest )
        state, rest = parse_str ( rest, "ms" )
        rest = skip_layout ( rest )

        lost_datagrams, rest = parse_num ( rest )
        state, rest = parse_str ( rest, "/" )
        rest = skip_layout ( rest )
        total_datagrams, rest = parse_num ( rest )
        rest = skip_layout ( rest )

        state, rest = parse_str ( rest, "(" )
        percent, rest = parse_num ( rest )
        state, rest = parse_str ( rest, "%" )
        state, rest = parse_str ( rest, ")" )
    end

    out.id = tonumber ( id )
    out.interval_start = tonumber ( interval_start )
    out.interval_end = tonumber ( interval_end )
    out.transfer = tonumber ( transfer )
    out.bandwidth = tonumber ( bandwidth )
    out.jitter = tonumber ( jitter )
    out.lost_datagrams = tonumber ( lost_datagrams )
    out.total_datagrams = tonumber ( total_datagrams )
    out.percent = tonumber ( percent )

    return out
end
