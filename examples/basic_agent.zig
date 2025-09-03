const std = @import("std");
const nen = @import("nen");

pub fn main() !void {
    std.debug.print("🤖 Nen Basic Agent Example\n", .{});
    std.debug.print("==============================\n\n", .{});

    const allocator = std.heap.page_allocator;

    // Create a simple agent flow
    var flow = try nen.createAgentFlow(allocator, "Basic Assistant", "You are a helpful AI assistant. Answer questions clearly and concisely.");
    defer flow.deinit();

    std.debug.print("🚀 Created agent: Basic Assistant\n", .{});
    std.debug.print("📝 Instructions: Answer questions clearly and concisely\n\n", .{});

    // Execute the agent flow
    std.debug.print("⚡ Executing agent flow...\n", .{});
    const start_time = std.time.nanoTimestamp();

    try flow.execute();

    const end_time = std.time.nanoTimestamp();
    const duration_ns = @as(u64, @intCast(end_time - start_time));
    const duration_ms = @as(f64, @floatFromInt(duration_ns)) / 1_000_000.0;

    std.debug.print("✅ Agent execution completed in {d:.2} ms\n\n", .{duration_ms});

    // Get execution statistics
    const stats = flow.getStats();
    std.debug.print("📊 Execution Statistics:\n", .{});
    std.debug.print("   • Total nodes: {d}\n", .{stats.total_nodes});
    std.debug.print("   • Completed nodes: {d}\n", .{stats.completed_nodes});
    std.debug.print("   • Failed nodes: {d}\n", .{stats.failed_nodes});
    std.debug.print("   • Success rate: {d:.1}%\n", .{stats.getSuccessRate() * 100.0});
    std.debug.print("   • Cache hit rate: {d:.1}%\n", .{stats.cache_hit_rate * 100.0});

    std.debug.print("\n🎉 Basic agent example completed successfully!\n", .{});
    std.debug.print("💡 This demonstrates the core Nen agent functionality\n", .{});
}
