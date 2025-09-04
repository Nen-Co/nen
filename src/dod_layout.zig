// Nen Framework Data-Oriented Design (DOD) Layout
// Implements Struct of Arrays (SoA) for high-performance workflow execution

const std = @import("std");
const dod_config = @import("dod_config.zig");

// DOD Node data structures using Struct of Arrays (SoA) layout
pub const DODNodeLayout = struct {
    // Node operations in SoA format
    node_ids: [dod_config.DOD_CONSTANTS.MAX_NODES][dod_config.DOD_CONSTANTS.NODE_SIZE_SMALL]u8 align(dod_config.DOD_CONSTANTS.SIMD_ALIGNMENT),
    node_types: [dod_config.DOD_CONSTANTS.MAX_NODES]u8 align(dod_config.DOD_CONSTANTS.CACHE_LINE_SIZE),
    node_states: [dod_config.DOD_CONSTANTS.MAX_NODES]u8 align(dod_config.DOD_CONSTANTS.CACHE_LINE_SIZE),
    node_data: [dod_config.DOD_CONSTANTS.MAX_NODES][dod_config.DOD_CONSTANTS.NODE_SIZE_MEDIUM]u8 align(dod_config.DOD_CONSTANTS.SIMD_ALIGNMENT),
    node_data_sizes: [dod_config.DOD_CONSTANTS.MAX_NODES]u32 align(dod_config.DOD_CONSTANTS.CACHE_LINE_SIZE),
    node_active: [dod_config.DOD_CONSTANTS.MAX_NODES]bool align(dod_config.DOD_CONSTANTS.CACHE_LINE_SIZE),
    node_timestamps: [dod_config.DOD_CONSTANTS.MAX_NODES]u64 align(dod_config.DOD_CONSTANTS.CACHE_LINE_SIZE),
    node_execution_times: [dod_config.DOD_CONSTANTS.MAX_NODES]u64 align(dod_config.DOD_CONSTANTS.CACHE_LINE_SIZE),
    node_retry_counts: [dod_config.DOD_CONSTANTS.MAX_NODES]u32 align(dod_config.DOD_CONSTANTS.CACHE_LINE_SIZE),
    node_priorities: [dod_config.DOD_CONSTANTS.MAX_NODES]u8 align(dod_config.DOD_CONSTANTS.CACHE_LINE_SIZE),
    
    // Dependencies in SoA format
    dependency_sources: [dod_config.DOD_CONSTANTS.MAX_NODES][dod_config.DOD_CONSTANTS.MAX_DEPENDENCIES]u32 align(dod_config.DOD_CONSTANTS.CACHE_LINE_SIZE),
    dependency_targets: [dod_config.DOD_CONSTANTS.MAX_NODES][dod_config.DOD_CONSTANTS.MAX_DEPENDENCIES]u32 align(dod_config.DOD_CONSTANTS.CACHE_LINE_SIZE),
    dependency_counts: [dod_config.DOD_CONSTANTS.MAX_NODES]u32 align(dod_config.DOD_CONSTANTS.CACHE_LINE_SIZE),
    dependency_active: [dod_config.DOD_CONSTANTS.MAX_NODES]bool align(dod_config.DOD_CONSTANTS.CACHE_LINE_SIZE),
    
    // Statistics
    node_count: u32 = 0,
    
    pub fn init() DODNodeLayout {
        return DODNodeLayout{
            .node_ids = [_][dod_config.DOD_CONSTANTS.NODE_SIZE_SMALL]u8{[_]u8{0} ** dod_config.DOD_CONSTANTS.NODE_SIZE_SMALL} ** dod_config.DOD_CONSTANTS.MAX_NODES,
            .node_types = [_]u8{0} ** dod_config.DOD_CONSTANTS.MAX_NODES,
            .node_states = [_]u8{0} ** dod_config.DOD_CONSTANTS.MAX_NODES,
            .node_data = [_][dod_config.DOD_CONSTANTS.NODE_SIZE_MEDIUM]u8{[_]u8{0} ** dod_config.DOD_CONSTANTS.NODE_SIZE_MEDIUM} ** dod_config.DOD_CONSTANTS.MAX_NODES,
            .node_data_sizes = [_]u32{0} ** dod_config.DOD_CONSTANTS.MAX_NODES,
            .node_active = [_]bool{false} ** dod_config.DOD_CONSTANTS.MAX_NODES,
            .node_timestamps = [_]u64{0} ** dod_config.DOD_CONSTANTS.MAX_NODES,
            .node_execution_times = [_]u64{0} ** dod_config.DOD_CONSTANTS.MAX_NODES,
            .node_retry_counts = [_]u32{0} ** dod_config.DOD_CONSTANTS.MAX_NODES,
            .node_priorities = [_]u8{0} ** dod_config.DOD_CONSTANTS.MAX_NODES,
            .dependency_sources = [_][dod_config.DOD_CONSTANTS.MAX_DEPENDENCIES]u32{[_]u32{0} ** dod_config.DOD_CONSTANTS.MAX_DEPENDENCIES} ** dod_config.DOD_CONSTANTS.MAX_NODES,
            .dependency_targets = [_][dod_config.DOD_CONSTANTS.MAX_DEPENDENCIES]u32{[_]u32{0} ** dod_config.DOD_CONSTANTS.MAX_DEPENDENCIES} ** dod_config.DOD_CONSTANTS.MAX_NODES,
            .dependency_counts = [_]u32{0} ** dod_config.DOD_CONSTANTS.MAX_NODES,
            .dependency_active = [_]bool{false} ** dod_config.DOD_CONSTANTS.MAX_NODES,
        };
    }
    
    // Node operations with DOD optimization
    pub fn addNode(self: *DODNodeLayout, id: []const u8, node_type: u8, data: []const u8, priority: u8) !u32 {
        if (self.node_count >= dod_config.DOD_CONSTANTS.MAX_NODES) {
            return dod_config.DODError.PoolExhausted;
        }
        
        const index = self.node_count;
        const id_size = @min(id.len, dod_config.DOD_CONSTANTS.NODE_SIZE_SMALL - 1);
        const data_size = @min(data.len, dod_config.DOD_CONSTANTS.NODE_SIZE_MEDIUM - 1);
        
        @memcpy(self.node_ids[index][0..id_size], id[0..id_size]);
        self.node_ids[index][id_size] = 0; // Null terminate
        self.node_types[index] = node_type;
        self.node_states[index] = 0; // Pending
        @memcpy(self.node_data[index][0..data_size], data[0..data_size]);
        self.node_data[index][data_size] = 0; // Null terminate
        self.node_data_sizes[index] = @intCast(data_size);
        self.node_active[index] = true;
        self.node_timestamps[index] = @as(u64, @intCast(std.time.nanoTimestamp()));
        self.node_execution_times[index] = 0;
        self.node_retry_counts[index] = 0;
        self.node_priorities[index] = priority;
        
        self.node_count += 1;
        return index;
    }
    
    // Add dependency
    pub fn addDependency(self: *DODNodeLayout, node_index: u32, target_index: u32) !void {
        if (node_index >= self.node_count or target_index >= self.node_count) {
            return dod_config.DODError.NodeOverflow;
        }
        
        const dep_count = self.dependency_counts[node_index];
        if (dep_count >= dod_config.DOD_CONSTANTS.MAX_DEPENDENCIES) {
            return dod_config.DODError.NodeOverflow;
        }
        
        self.dependency_sources[node_index][dep_count] = node_index;
        self.dependency_targets[node_index][dep_count] = target_index;
        self.dependency_counts[node_index] += 1;
        self.dependency_active[node_index] = true;
    }
    
    // SIMD-optimized node execution
    pub fn executeNodesSIMD(self: *DODNodeLayout, node_indices: []const u32, execution_times: []u64) !u32 {
        var executed_count: u32 = 0;
        const simd_batch_size = dod_config.DOD_CONSTANTS.SIMD_NODE_BATCH;
        
        var i: u32 = 0;
        while (i < node_indices.len and executed_count < execution_times.len) {
            const batch_size = @min(simd_batch_size, node_indices.len - i);
            
            // Process batch with SIMD optimization
            for (i..i + batch_size) |j| {
                const node_idx = node_indices[j];
                if (node_idx < self.node_count and self.node_active[node_idx]) {
                    const start_time = std.time.nanoTimestamp();
                    
                    // Simulate node execution
                    self.node_states[node_idx] = 1; // Running
                    std.Thread.sleep(1000); // 1μs simulation
                    self.node_states[node_idx] = 2; // Completed
                    
                    const end_time = std.time.nanoTimestamp();
                    const exec_time = end_time - start_time;
                    self.node_execution_times[node_idx] = exec_time;
                    
                    if (executed_count < execution_times.len) {
                        execution_times[executed_count] = exec_time;
                        executed_count += 1;
                    }
                }
            }
            
            i += batch_size;
        }
        
        return executed_count;
    }
    
    // Get node statistics
    pub fn getStats(self: *const DODNodeLayout) DODNodeStats {
        return DODNodeStats{
            .node_count = self.node_count,
            .node_capacity = dod_config.DOD_CONSTANTS.MAX_NODES,
            .active_nodes = self.countActiveNodes(),
            .completed_nodes = self.countCompletedNodes(),
            .failed_nodes = self.countFailedNodes(),
        };
    }
    
    fn countActiveNodes(self: *const DODNodeLayout) u32 {
        var count: u32 = 0;
        for (0..self.node_count) |i| {
            if (self.node_active[i]) count += 1;
        }
        return count;
    }
    
    fn countCompletedNodes(self: *const DODNodeLayout) u32 {
        var count: u32 = 0;
        for (0..self.node_count) |i| {
            if (self.node_active[i] and self.node_states[i] == 2) count += 1;
        }
        return count;
    }
    
    fn countFailedNodes(self: *const DODNodeLayout) u32 {
        var count: u32 = 0;
        for (0..self.node_count) |i| {
            if (self.node_active[i] and self.node_states[i] == 3) count += 1;
        }
        return count;
    }
};

// DOD Flow data structures using Struct of Arrays (SoA) layout
pub const DODFlowLayout = struct {
    // Flow operations in SoA format
    flow_ids: [dod_config.DOD_CONSTANTS.MAX_FLOWS][dod_config.DOD_CONSTANTS.MAX_FLOW_ID_SIZE]u8 align(dod_config.DOD_CONSTANTS.SIMD_ALIGNMENT),
    flow_states: [dod_config.DOD_CONSTANTS.MAX_FLOWS]u8 align(dod_config.DOD_CONSTANTS.CACHE_LINE_SIZE),
    flow_node_counts: [dod_config.DOD_CONSTANTS.MAX_FLOWS]u32 align(dod_config.DOD_CONSTANTS.CACHE_LINE_SIZE),
    flow_active: [dod_config.DOD_CONSTANTS.MAX_FLOWS]bool align(dod_config.DOD_CONSTANTS.CACHE_LINE_SIZE),
    flow_timestamps: [dod_config.DOD_CONSTANTS.MAX_FLOWS]u64 align(dod_config.DOD_CONSTANTS.CACHE_LINE_SIZE),
    flow_execution_times: [dod_config.DOD_CONSTANTS.MAX_FLOWS]u64 align(dod_config.DOD_CONSTANTS.CACHE_LINE_SIZE),
    flow_retry_counts: [dod_config.DOD_CONSTANTS.MAX_FLOWS]u32 align(dod_config.DOD_CONSTANTS.CACHE_LINE_SIZE),
    flow_priorities: [dod_config.DOD_CONSTANTS.MAX_FLOWS]u8 align(dod_config.DOD_CONSTANTS.CACHE_LINE_SIZE),
    
    // Node references in SoA format
    flow_node_refs: [dod_config.DOD_CONSTANTS.MAX_FLOWS][dod_config.DOD_CONSTANTS.MAX_NODES]u32 align(dod_config.DOD_CONSTANTS.CACHE_LINE_SIZE),
    flow_node_ref_counts: [dod_config.DOD_CONSTANTS.MAX_FLOWS]u32 align(dod_config.DOD_CONSTANTS.CACHE_LINE_SIZE),
    
    // Statistics
    flow_count: u32 = 0,
    
    pub fn init() DODFlowLayout {
        return DODFlowLayout{
            .flow_ids = [_][dod_config.DOD_CONSTANTS.MAX_FLOW_ID_SIZE]u8{[_]u8{0} ** dod_config.DOD_CONSTANTS.MAX_FLOW_ID_SIZE} ** dod_config.DOD_CONSTANTS.MAX_FLOWS,
            .flow_states = [_]u8{0} ** dod_config.DOD_CONSTANTS.MAX_FLOWS,
            .flow_node_counts = [_]u32{0} ** dod_config.DOD_CONSTANTS.MAX_FLOWS,
            .flow_active = [_]bool{false} ** dod_config.DOD_CONSTANTS.MAX_FLOWS,
            .flow_timestamps = [_]u64{0} ** dod_config.DOD_CONSTANTS.MAX_FLOWS,
            .flow_execution_times = [_]u64{0} ** dod_config.DOD_CONSTANTS.MAX_FLOWS,
            .flow_retry_counts = [_]u32{0} ** dod_config.DOD_CONSTANTS.MAX_FLOWS,
            .flow_priorities = [_]u8{0} ** dod_config.DOD_CONSTANTS.MAX_FLOWS,
            .flow_node_refs = [_][dod_config.DOD_CONSTANTS.MAX_NODES]u32{[_]u32{0} ** dod_config.DOD_CONSTANTS.MAX_NODES} ** dod_config.DOD_CONSTANTS.MAX_FLOWS,
            .flow_node_ref_counts = [_]u32{0} ** dod_config.DOD_CONSTANTS.MAX_FLOWS,
        };
    }
    
    // Flow operations with DOD optimization
    pub fn addFlow(self: *DODFlowLayout, id: []const u8, priority: u8) !u32 {
        if (self.flow_count >= dod_config.DOD_CONSTANTS.MAX_FLOWS) {
            return dod_config.DODError.PoolExhausted;
        }
        
        const index = self.flow_count;
        const id_size = @min(id.len, dod_config.DOD_CONSTANTS.MAX_FLOW_ID_SIZE - 1);
        
        @memcpy(self.flow_ids[index][0..id_size], id[0..id_size]);
        self.flow_ids[index][id_size] = 0; // Null terminate
        self.flow_states[index] = 0; // Pending
        self.flow_node_counts[index] = 0;
        self.flow_active[index] = true;
        self.flow_timestamps[index] = @as(u64, @intCast(std.time.nanoTimestamp()));
        self.flow_execution_times[index] = 0;
        self.flow_retry_counts[index] = 0;
        self.flow_priorities[index] = priority;
        
        self.flow_count += 1;
        return index;
    }
    
    // Add node to flow
    pub fn addNodeToFlow(self: *DODFlowLayout, flow_index: u32, node_index: u32) !void {
        if (flow_index >= self.flow_count or node_index >= dod_config.DOD_CONSTANTS.MAX_NODES) {
            return dod_config.DODError.FlowOverflow;
        }
        
        const ref_count = self.flow_node_ref_counts[flow_index];
        if (ref_count >= dod_config.DOD_CONSTANTS.MAX_NODES) {
            return dod_config.DODError.FlowOverflow;
        }
        
        self.flow_node_refs[flow_index][ref_count] = node_index;
        self.flow_node_ref_counts[flow_index] += 1;
        self.flow_node_counts[flow_index] += 1;
    }
    
    // SIMD-optimized flow execution
    pub fn executeFlowsSIMD(self: *DODFlowLayout, flow_indices: []const u32, execution_times: []u64) !u32 {
        var executed_count: u32 = 0;
        const simd_batch_size = dod_config.DOD_CONSTANTS.SIMD_FLOW_BATCH;
        
        var i: u32 = 0;
        while (i < flow_indices.len and executed_count < execution_times.len) {
            const batch_size = @min(simd_batch_size, flow_indices.len - i);
            
            // Process batch with SIMD optimization
            for (i..i + batch_size) |j| {
                const flow_idx = flow_indices[j];
                if (flow_idx < self.flow_count and self.flow_active[flow_idx]) {
                    const start_time = std.time.nanoTimestamp();
                    
                    // Simulate flow execution
                    self.flow_states[flow_idx] = 1; // Running
                    std.Thread.sleep(10000); // 10μs simulation
                    self.flow_states[flow_idx] = 2; // Completed
                    
                    const end_time = std.time.nanoTimestamp();
                    const exec_time = end_time - start_time;
                    self.flow_execution_times[flow_idx] = exec_time;
                    
                    if (executed_count < execution_times.len) {
                        execution_times[executed_count] = exec_time;
                        executed_count += 1;
                    }
                }
            }
            
            i += batch_size;
        }
        
        return executed_count;
    }
    
    // Get flow statistics
    pub fn getStats(self: *const DODFlowLayout) DODFlowStats {
        return DODFlowStats{
            .flow_count = self.flow_count,
            .flow_capacity = dod_config.DOD_CONSTANTS.MAX_FLOWS,
            .active_flows = self.countActiveFlows(),
            .completed_flows = self.countCompletedFlows(),
            .failed_flows = self.countFailedFlows(),
        };
    }
    
    fn countActiveFlows(self: *const DODFlowLayout) u32 {
        var count: u32 = 0;
        for (0..self.flow_count) |i| {
            if (self.flow_active[i]) count += 1;
        }
        return count;
    }
    
    fn countCompletedFlows(self: *const DODFlowLayout) u32 {
        var count: u32 = 0;
        for (0..self.flow_count) |i| {
            if (self.flow_active[i] and self.flow_states[i] == 2) count += 1;
        }
        return count;
    }
    
    fn countFailedFlows(self: *const DODFlowLayout) u32 {
        var count: u32 = 0;
        for (0..self.flow_count) |i| {
            if (self.flow_active[i] and self.flow_states[i] == 3) count += 1;
        }
        return count;
    }
};

// DOD Node statistics
pub const DODNodeStats = struct {
    node_count: u32,
    node_capacity: u32,
    active_nodes: u32,
    completed_nodes: u32,
    failed_nodes: u32,
    
    pub fn getNodeUtilization(self: DODNodeStats) f32 {
        return @as(f32, @floatFromInt(self.node_count)) / @as(f32, @floatFromInt(self.node_capacity));
    }
    
    pub fn getSuccessRate(self: DODNodeStats) f32 {
        const total = self.completed_nodes + self.failed_nodes;
        if (total == 0) return 0.0;
        return @as(f32, @floatFromInt(self.completed_nodes)) / @as(f32, @floatFromInt(total));
    }
    
    pub fn getActiveRate(self: DODNodeStats) f32 {
        if (self.node_count == 0) return 0.0;
        return @as(f32, @floatFromInt(self.active_nodes)) / @as(f32, @floatFromInt(self.node_count));
    }
};

// DOD Flow statistics
pub const DODFlowStats = struct {
    flow_count: u32,
    flow_capacity: u32,
    active_flows: u32,
    completed_flows: u32,
    failed_flows: u32,
    
    pub fn getFlowUtilization(self: DODFlowStats) f32 {
        return @as(f32, @floatFromInt(self.flow_count)) / @as(f32, @floatFromInt(self.flow_capacity));
    }
    
    pub fn getSuccessRate(self: DODFlowStats) f32 {
        const total = self.completed_flows + self.failed_flows;
        if (total == 0) return 0.0;
        return @as(f32, @floatFromInt(self.completed_flows)) / @as(f32, @floatFromInt(total));
    }
    
    pub fn getActiveRate(self: DODFlowStats) f32 {
        if (self.flow_count == 0) return 0.0;
        return @as(f32, @floatFromInt(self.active_flows)) / @as(f32, @floatFromInt(self.flow_count));
    }
};
