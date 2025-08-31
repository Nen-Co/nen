const std = @import("std");
const nen = @import("nen");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    
    try stdout.writeAll("🔄 NenFlow Multi-step Workflow Demo\n");
    try stdout.writeAll("====================================\n\n");
    
    const allocator = std.heap.page_allocator;
    
    // Demo 1: Software Development Workflow
    try stdout.writeAll("1️⃣ Software Development Workflow\n");
    try stdout.writeAll("=================================\n");
    
    const dev_steps = [_][]const u8{
        "Analyze Requirements",
        "Design Architecture", 
        "Implement Core Features",
        "Write Tests",
        "Deploy to Production",
    };
    
    var dev_workflow = try nen.createWorkflowFlow(allocator, &dev_steps);
    defer dev_workflow.deinit();
    
    try stdout.writeAll("   🚀 Created: Software Development Workflow\n");
    try stdout.writeAll("   📋 Steps:\n");
    for (dev_steps, 0..) |step, i| {
        try stdout.print("      {d}. {s}\n", .{i + 1, step});
    }
    
    try dev_workflow.execute();
    const dev_stats = dev_workflow.getStats();
    try stdout.print("   ✅ Completed in {d:.2} ms\n", .{dev_stats.getExecutionTimeMs()});
    
    // Demo 2: Data Processing Workflow
    try stdout.writeAll("\n2️⃣ Data Processing Workflow\n");
    try stdout.writeAll("===========================\n");
    
    const data_steps = [_][]const u8{
        "Data Collection",
        "Data Cleaning",
        "Data Analysis",
        "Model Training",
        "Results Validation",
        "Report Generation",
    };
    
    var data_workflow = try nen.createWorkflowFlow(allocator, &data_steps);
    defer data_workflow.deinit();
    
    try stdout.writeAll("   🚀 Created: Data Processing Workflow\n");
    try stdout.writeAll("   📊 Steps:\n");
    for (data_steps, 0..) |step, i| {
        try stdout.print("      {d}. {s}\n", .{i + 1, step});
    }
    
    try data_workflow.execute();
    const data_stats = data_workflow.getStats();
    try stdout.print("   ✅ Completed in {d:.2} ms\n", .{data_stats.getExecutionTimeMs()});
    
    // Demo 3: Content Creation Workflow
    try stdout.writeAll("\n3️⃣ Content Creation Workflow\n");
    try stdout.writeAll("=============================\n");
    
    const content_steps = [_][]const u8{
        "Topic Research",
        "Outline Creation",
        "Content Writing",
        "Editing and Review",
        "SEO Optimization",
        "Publication",
    };
    
    var content_workflow = try nen.createWorkflowFlow(allocator, &content_steps);
    defer content_workflow.deinit();
    
    try stdout.writeAll("   🚀 Created: Content Creation Workflow\n");
    try stdout.writeAll("   ✍️ Steps:\n");
    for (content_steps, 0..) |step, i| {
        try stdout.print("      {d}. {s}\n", .{i + 1, step});
    }
    
    try content_workflow.execute();
    const content_stats = content_workflow.getStats();
    try stdout.print("   ✅ Completed in {d:.2} ms\n", .{content_stats.getExecutionTimeMs()});
    
    // Demo 4: Customer Support Workflow
    try stdout.writeAll("\n4️⃣ Customer Support Workflow\n");
    try stdout.writeAll("=============================\n");
    
    const support_steps = [_][]const u8{
        "Ticket Creation",
        "Issue Classification",
        "Initial Response",
        "Problem Investigation",
        "Solution Implementation",
        "Customer Follow-up",
        "Ticket Resolution",
    };
    
    var support_workflow = try nen.createWorkflowFlow(allocator, &support_steps);
    defer support_workflow.deinit();
    
    try stdout.writeAll("   🚀 Created: Customer Support Workflow\n");
    try stdout.writeAll("   🎧 Steps:\n");
    for (support_steps, 0..) |step, i| {
        try stdout.print("      {d}. {s}\n", .{i + 1, step});
    }
    
    try support_workflow.execute();
    const support_stats = support_workflow.getStats();
    try stdout.print("   ✅ Completed in {d:.2} ms\n", .{support_stats.getExecutionTimeMs()});
    
    // Performance Summary
    try stdout.writeAll("\n📊 Workflow Performance Summary\n");
    try stdout.writeAll("================================\n");
    
    const total_workflows = 4;
    const total_steps = dev_steps.len + data_steps.len + content_steps.len + support_steps.len;
    const total_time = dev_stats.getExecutionTimeMs() + 
                      data_stats.getExecutionTimeMs() + 
                      content_stats.getExecutionTimeMs() + 
                      support_stats.getExecutionTimeMs();
    
    try stdout.print("   • Total workflows: {d}\n", .{total_workflows});
    try stdout.print("   • Total steps: {d}\n", .{total_steps});
    try stdout.print("   • Total execution time: {d:.2} ms\n", .{total_time});
    try stdout.print("   • Average per workflow: {d:.2} ms\n", .{total_time / total_workflows});
    try stdout.print("   • Average per step: {d:.2} ms\n", .{total_time / total_steps});
    try stdout.print("   • Throughput: {d:.0} workflows/sec\n", .{1000.0 / (total_time / total_workflows)});
    
    try stdout.writeAll("\n🎯 Workflow Capabilities Demonstrated:\n");
    try stdout.writeAll("   • Software development lifecycle\n");
    try stdout.writeAll("   • Data processing pipelines\n");
    try stdout.writeAll("   • Content creation processes\n");
    try stdout.writeAll("   • Customer support operations\n");
    
    try stdout.writeAll("\n🔄 Workflow Features:\n");
    try stdout.writeAll("   • Step-by-step execution\n");
    try stdout.writeAll("   • Dependency management\n");
    try stdout.writeAll("   • Error handling and recovery\n");
    try stdout.writeAll("   • Performance monitoring\n");
    try stdout.writeAll("   • Scalable orchestration\n");
    
    try stdout.writeAll("\n🚀 NenFlow workflows are production-ready!\n");
    try stdout.writeAll("💡 Perfect for business process automation and complex task orchestration\n");
}
