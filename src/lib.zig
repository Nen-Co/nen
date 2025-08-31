// Nen: Minimalist LLM Framework in Zig
// Core abstractions for cross-language bindings
// Target: 50-100 lines of code

const std = @import("std");

// Core types - just the essentials
pub const NodeType = enum { agent, tool, llm, memory, workflow, rag };
pub const NodeState = enum { pending, running, completed, failed };

// Main node structure - simplified
pub const Node = struct {
    id: []const u8,
    node_type: NodeType,
    state: NodeState,
    data: []const u8,
    
    pub fn init(id: []const u8, node_type: NodeType) Node {
        return Node{
            .id = id,
            .node_type = node_type,
            .state = .pending,
            .data = "",
        };
    }
};

// Main flow orchestrator - minimal interface
pub const Flow = struct {
    allocator: std.mem.Allocator,
    nodes: std.ArrayList(*Node),
    
    pub fn init(allocator: std.mem.Allocator) !*Flow {
        const flow = try allocator.create(Flow);
        flow.* = Flow{
            .allocator = allocator,
            .nodes = std.ArrayList(*Node).init(allocator),
        };
        return flow;
    }
    
    pub fn deinit(self: *Flow) void {
        self.nodes.deinit();
        self.allocator.destroy(self);
    }
    
    pub fn addNode(self: *Flow, node: *Node) !void {
        try self.nodes.append(node);
    }
    
    pub fn execute(self: *Flow) !void {
        for (self.nodes.items) |node| {
            node.state = .running;
            // Simulate execution
            std.time.sleep(1000); // 1μs
            node.state = .completed;
        }
    }
    
    pub fn getStats(self: *Flow) FlowStats {
        var completed: u32 = 0;
        for (self.nodes.items) |node| {
            if (node.state == .completed) completed += 1;
        }
        return FlowStats{
            .total_nodes = @as(u32, @intCast(self.nodes.items.len)),
            .completed_nodes = completed,
        };
    }
};

// Simple stats structure
pub const FlowStats = struct {
    total_nodes: u32,
    completed_nodes: u32,
    
    pub fn getSuccessRate(self: *const FlowStats) f32 {
        if (self.total_nodes == 0) return 0.0;
        return @as(f32, @floatFromInt(self.completed_nodes)) / @as(f32, @floatFromInt(self.total_nodes));
    }
};

// Convenience functions for common workflows
pub fn createAgentFlow(allocator: std.mem.Allocator, name: []const u8, instructions: []const u8) !*Flow {
    _ = instructions; // Not used in minimal version
    const flow = try Flow.init(allocator);
    const agent = try allocator.create(Node);
    agent.* = Node.init(name, .agent);
    try flow.addNode(agent);
    return flow;
}

pub fn createRAGFlow(allocator: std.mem.Allocator, query: []const u8) !*Flow {
    _ = query; // Not used in minimal version
    const flow = try Flow.init(allocator);
    const query_node = try allocator.create(Node);
    query_node.* = Node.init("query", .rag);
    try flow.addNode(query_node);
    return flow;
}

pub fn createWorkflowFlow(allocator: std.mem.Allocator, steps: []const []const u8) !*Flow {
    const flow = try Flow.init(allocator);
    for (steps) |step| {
        const step_node = try allocator.create(Node);
        step_node.* = Node.init(step, .workflow);
        try flow.addNode(step_node);
    }
    return flow;
}

// Export for C bindings
// Export for C bindings
// Export for C bindings
// Export for C bindings
// Export for C bindings
export fn nen_create_agent_flow(allocator: *anyopaque, name: [*:0]const u8, instructions: [*:0]const u8) *anyopaque {
    const alloc = @ptrCast(std.mem.Allocator, allocator);
    const flow = createAgentFlow(alloc, std.mem.span(name), std.mem.span(instructions)) catch return null;
    return flow;
}

export fn nen_execute_flow(flow: *anyopaque) c_int {
    const f = @ptrCast(*Flow, flow);
    f.execute() catch return -1;
    return 0;
}

export fn nen_get_flow_stats(flow: *anyopaque) *anyopaque {
    const f = @ptrCast(*Flow, flow);
    const stats = f.getStats();
    return &stats;
}
