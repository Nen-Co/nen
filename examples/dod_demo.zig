// Nen Framework Data-Oriented Design (DOD) Demo
// Demonstrates the performance benefits of DOD architecture for workflow execution

const std = @import("std");
const nen = @import("nen");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    std.debug.print("🚀 Nen Framework Data-Oriented Design (DOD) Demo\n", .{});
    std.debug.print("===============================================\n\n", .{});

    // Initialize DOD layouts
    var node_layout = nen.dod_layout.DODNodeLayout.init();
    var flow_layout = nen.dod_layout.DODFlowLayout.init();
    var prefetch_system = nen.dod_prefetch.WorkflowPrefetchSystem.init(nen.dod_prefetch.WorkflowPrefetchConfig{});

    // Demo 1: SoA vs AoS Performance for Workflow Operations
    std.debug.print("📊 Demo 1: Struct of Arrays (SoA) Workflow Performance\n", .{});
    std.debug.print("----------------------------------------------------\n", .{});

    const num_nodes = 100;
    const num_flows = 20;

    // Add nodes using SoA layout
    const start_time = std.time.nanoTimestamp();

    for (0..num_nodes) |i| {
        const node_id = try std.fmt.allocPrint(gpa.allocator(), "node_{d}", .{i});
        defer gpa.allocator().free(node_id);
        const node_data = try std.fmt.allocPrint(gpa.allocator(), "data_{d}", .{i});
        defer gpa.allocator().free(node_data);
        _ = try node_layout.addNode(node_id, @intCast(i % 6), node_data, @intCast(i % 8)); // Different types and priorities
    }

    for (0..num_flows) |i| {
        const flow_id = try std.fmt.allocPrint(gpa.allocator(), "flow_{d}", .{i});
        defer gpa.allocator().free(flow_id);
        _ = try flow_layout.addFlow(flow_id, @intCast(i % 8)); // Different priorities
    }

    const end_time = std.time.nanoTimestamp();
    const duration_ns = end_time - start_time;
    const duration_ms = @as(f64, @floatFromInt(duration_ns)) / 1_000_000.0;

    std.debug.print("✅ Added {d} nodes and {d} flows in {d:.2}ms\n", .{ num_nodes, num_flows, duration_ms });
    std.debug.print("⚡ Performance: {d:.0} operations/second\n\n", .{@as(f64, @floatFromInt(num_nodes + num_flows)) / (duration_ms / 1000.0)});

    // Demo 2: SIMD-Optimized Node Execution
    std.debug.print("🔍 Demo 2: SIMD-Optimized Node Execution\n", .{});
    std.debug.print("---------------------------------------\n", .{});

    var node_indices: [10]u32 = undefined;
    for (0..10) |i| {
        node_indices[i] = @intCast(i);
    }

    var execution_times: [10]u64 = undefined;

    const simd_start = std.time.nanoTimestamp();
    const executed_count = nen.dod_simd.DODSIMDOperations.executeNodesSIMD(&node_layout, &node_indices, &execution_times);
    const simd_end = std.time.nanoTimestamp();
    const simd_duration_ns = simd_end - simd_start;
    const simd_duration_ms = @as(f64, @floatFromInt(simd_duration_ns)) / 1_000_000.0;

    std.debug.print("✅ Executed {d} nodes using SIMD in {d:.3}ms\n", .{ executed_count, simd_duration_ms });
    std.debug.print("⚡ SIMD node performance: {d:.0} nodes/second\n\n", .{@as(f64, @floatFromInt(executed_count)) / (simd_duration_ms / 1000.0)});

    // Demo 3: SIMD Flow Execution
    std.debug.print("🔄 Demo 3: SIMD Flow Execution\n", .{});
    std.debug.print("------------------------------\n", .{});

    var flow_indices: [5]u32 = undefined;
    for (0..5) |i| {
        flow_indices[i] = @intCast(i);
    }

    var flow_execution_times: [5]u64 = undefined;

    const flow_start = std.time.nanoTimestamp();
    const flow_executed_count = nen.dod_simd.DODSIMDOperations.executeFlowsSIMD(&flow_layout, &flow_indices, &flow_execution_times);
    const flow_end = std.time.nanoTimestamp();
    const flow_duration_ns = flow_end - flow_start;
    const flow_duration_ms = @as(f64, @floatFromInt(flow_duration_ns)) / 1_000_000.0;

    std.debug.print("✅ Executed {d} flows using SIMD in {d:.3}ms\n", .{ flow_executed_count, flow_duration_ms });
    std.debug.print("⚡ SIMD flow performance: {d:.0} flows/second\n\n", .{@as(f64, @floatFromInt(flow_executed_count)) / (flow_duration_ms / 1000.0)});

    // Demo 4: Prefetching for Workflow Execution
    std.debug.print("🎯 Demo 4: Workflow Prefetching System\n", .{});
    std.debug.print("--------------------------------------\n", .{});

    const prefetch_start = std.time.nanoTimestamp();

    // Prefetch nodes
    var prefetch_node_indices: [10]u32 = undefined;
    for (0..10) |i| {
        prefetch_node_indices[i] = @intCast(i);
    }
    prefetch_system.prefetchNodes(&node_layout, &prefetch_node_indices, .sequential_execution);

    // Prefetch flows
    var prefetch_flow_indices: [5]u32 = undefined;
    for (0..5) |i| {
        prefetch_flow_indices[i] = @intCast(i);
    }
    prefetch_system.prefetchFlows(&flow_layout, &prefetch_flow_indices, .parallel_execution);

    // Prefetch execution
    var prefetch_exec_indices: [8]u32 = undefined;
    for (0..8) |i| {
        prefetch_exec_indices[i] = @intCast(i);
    }
    prefetch_system.prefetchExecution(&node_layout, &flow_layout, &prefetch_exec_indices, .workflow_pattern);

    const prefetch_end = std.time.nanoTimestamp();
    const prefetch_duration_ns = prefetch_end - prefetch_start;
    const prefetch_duration_ms = @as(f64, @floatFromInt(prefetch_duration_ns)) / 1_000_000.0;

    std.debug.print("✅ Prefetched {d} nodes, {d} flows, and {d} executions in {d:.3}ms\n", .{ prefetch_node_indices.len, prefetch_flow_indices.len, prefetch_exec_indices.len, prefetch_duration_ms });

    // Demo 5: SIMD Statistics and Aggregation
    std.debug.print("\n📈 Demo 5: SIMD Statistics and Aggregation\n", .{});
    std.debug.print("-----------------------------------------\n", .{});

    var node_stats: [20]u64 = undefined;
    var flow_stats: [10]u64 = undefined;

    const stats_start = std.time.nanoTimestamp();
    const node_stats_count = nen.dod_simd.DODSIMDOperations.aggregateNodeStatsSIMD(&node_layout, &node_indices, &node_stats);
    const flow_stats_count = nen.dod_simd.DODSIMDOperations.aggregateFlowStatsSIMD(&flow_layout, &flow_indices, &flow_stats);
    const stats_end = std.time.nanoTimestamp();
    const stats_duration_ns = stats_end - stats_start;
    const stats_duration_ms = @as(f64, @floatFromInt(stats_duration_ns)) / 1_000_000.0;

    std.debug.print("✅ Aggregated {d} node stats and {d} flow stats using SIMD in {d:.3}ms\n", .{ node_stats_count, flow_stats_count, stats_duration_ms });

    // Demo 6: SIMD Node Filtering
    std.debug.print("\n🔍 Demo 6: SIMD Node Filtering\n", .{});
    std.debug.print("------------------------------\n", .{});

    var filtered_nodes: [20]u32 = undefined;

    const filter_start = std.time.nanoTimestamp();
    const filtered_count = nen.dod_simd.DODSIMDOperations.filterNodesByTypeSIMD(&node_layout, 0, &filtered_nodes); // Filter agent nodes
    const filter_end = std.time.nanoTimestamp();
    const filter_duration_ns = filter_end - filter_start;
    const filter_duration_ms = @as(f64, @floatFromInt(filter_duration_ns)) / 1_000_000.0;

    std.debug.print("✅ Filtered {d} agent nodes using SIMD in {d:.3}ms\n", .{ filtered_count, filter_duration_ms });

    // Demo 7: SIMD Parallel Execution
    std.debug.print("\n⚡ Demo 7: SIMD Parallel Execution\n", .{});
    std.debug.print("-----------------------------------\n", .{});

    var parallel_indices: [8]u32 = undefined;
    for (0..8) |i| {
        parallel_indices[i] = @intCast(i);
    }

    var parallel_results: [8]u64 = undefined;

    const parallel_start = std.time.nanoTimestamp();
    const parallel_count = nen.dod_simd.DODSIMDOperations.executeParallelSIMD(&node_layout, &flow_layout, &parallel_indices, &parallel_results);
    const parallel_end = std.time.nanoTimestamp();
    const parallel_duration_ns = parallel_end - parallel_start;
    const parallel_duration_ms = @as(f64, @floatFromInt(parallel_duration_ns)) / 1_000_000.0;

    std.debug.print("✅ Executed {d} parallel operations using SIMD in {d:.3}ms\n", .{ parallel_count, parallel_duration_ms });

    // Demo 8: Workflow Statistics
    std.debug.print("\n📊 Demo 8: DOD Workflow Statistics\n", .{});
    std.debug.print("-----------------------------------\n", .{});

    const node_stats_result = node_layout.getStats();
    const flow_stats_result = flow_layout.getStats();
    const prefetch_stats = prefetch_system.getStats();

    std.debug.print("📊 Node Layout Statistics:\n", .{});
    std.debug.print("   Nodes: {d}/{d} ({d:.1}% utilization)\n", .{ node_stats_result.node_count, node_stats_result.node_capacity, node_stats_result.getNodeUtilization() * 100.0 });
    std.debug.print("   Active: {d} ({d:.1}% active rate)\n", .{ node_stats_result.active_nodes, node_stats_result.getActiveRate() * 100.0 });
    std.debug.print("   Completed: {d} ({d:.1}% success rate)\n", .{ node_stats_result.completed_nodes, node_stats_result.getSuccessRate() * 100.0 });

    std.debug.print("\n📊 Flow Layout Statistics:\n", .{});
    std.debug.print("   Flows: {d}/{d} ({d:.1}% utilization)\n", .{ flow_stats_result.flow_count, flow_stats_result.flow_capacity, flow_stats_result.getFlowUtilization() * 100.0 });
    std.debug.print("   Active: {d} ({d:.1}% active rate)\n", .{ flow_stats_result.active_flows, flow_stats_result.getActiveRate() * 100.0 });
    std.debug.print("   Completed: {d} ({d:.1}% success rate)\n", .{ flow_stats_result.completed_flows, flow_stats_result.getSuccessRate() * 100.0 });

    std.debug.print("\n📊 Prefetch Statistics:\n", .{});
    std.debug.print("   Total prefetches: {d}\n", .{prefetch_stats.getTotalPrefetches()});
    std.debug.print("   Prefetch effectiveness: {d:.1}%\n", .{prefetch_stats.getPrefetchEffectiveness() * 100.0});
    std.debug.print("   Workflow prefetches: {d}\n", .{prefetch_stats.workflow_prefetches});

    // Demo 9: DOD Benefits Summary
    std.debug.print("\n🎯 DOD Benefits Demonstrated\n", .{});
    std.debug.print("----------------------------\n", .{});
    std.debug.print("✅ Struct of Arrays (SoA) layout for better cache locality\n", .{});
    std.debug.print("✅ SIMD-optimized workflow operations for vectorized processing\n", .{});
    std.debug.print("✅ Advanced prefetching system for workflow execution\n", .{});
    std.debug.print("✅ Static memory allocation for predictable performance\n", .{});
    std.debug.print("✅ Component-based architecture for flexible workflow modeling\n", .{});
    std.debug.print("✅ Parallel execution optimization with SIMD\n", .{});

    std.debug.print("\n🚀 Nen Framework DOD architecture delivers maximum workflow performance!\n", .{});
}
