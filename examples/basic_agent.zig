const std = @import("std");
const nen = @import("nen");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    
    try stdout.writeAll("🤖 NenFlow Basic Agent Example\n");
    try stdout.writeAll("==============================\n\n");
    
    const allocator = std.heap.page_allocator;
    
    // Create a simple agent flow
    var flow = try nen.createAgentFlow(allocator, "Basic Assistant", 
        "You are a helpful AI assistant. Answer questions clearly and concisely.");
    defer flow.deinit();
    
    try stdout.writeAll("🚀 Created agent: Basic Assistant\n");
    try stdout.writeAll("📝 Instructions: Answer questions clearly and concisely\n\n");
    
    // Execute the agent flow
    try stdout.writeAll("⚡ Executing agent flow...\n");
    const start_time = std.time.nanoTimestamp();
    
    try flow.execute();
    
    const end_time = std.time.nanoTimestamp();
    const duration_ns = @as(u64, @intCast(end_time - start_time));
    const duration_ms = @as(f64, @floatFromInt(duration_ns)) / 1_000_000.0;
    
    try stdout.print("✅ Agent execution completed in {d:.2} ms\n\n", .{duration_ms});
    
    // Get execution statistics
    const stats = flow.getStats();
    try stdout.writeAll("📊 Execution Statistics:\n");
    try stdout.print("   • Total nodes: {d}\n", .{stats.total_nodes});
    try stdout.print("   • Completed nodes: {d}\n", .{stats.completed_nodes});
    try stdout.print("   • Failed nodes: {d}\n", .{stats.failed_nodes});
    try stdout.print("   • Success rate: {d:.1}%\n", .{stats.getSuccessRate() * 100.0});
    try stdout.print("   • Cache hit rate: {d:.1}%\n", .{stats.cache_hit_rate * 100.0});
    
    try stdout.writeAll("\n🎉 Basic agent example completed successfully!\n");
    try stdout.writeAll("💡 This demonstrates the core NenFlow agent functionality\n");
}
