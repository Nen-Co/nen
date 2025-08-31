const std = @import("std");
const nen = @import("nen");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    
    try stdout.writeAll("🤖 NenFlow Advanced Agent Demo\n");
    try stdout.writeAll("===============================\n\n");
    
    const allocator = std.heap.page_allocator;
    
    // Demo 1: Research Agent
    try stdout.writeAll("1️⃣ Research Agent\n");
    try stdout.writeAll("================\n");
    
    var research_agent = try nen.createAgentFlow(allocator, "Research Agent", 
        "You are a research assistant. Help users find information and answer questions.");
    defer research_agent.deinit();
    
    try stdout.writeAll("   🔬 Created: Research Agent\n");
    try stdout.writeAll("   📚 Role: Information research and Q&A\n");
    
    try research_agent.execute();
    const research_stats = research_agent.getStats();
    try stdout.print("   ✅ Completed in {d:.2} ms\n", .{research_stats.getExecutionTimeMs()});
    
    // Demo 2: Code Assistant Agent
    try stdout.writeAll("\n2️⃣ Code Assistant Agent\n");
    try stdout.writeAll("======================\n");
    
    var code_agent = try nen.createAgentFlow(allocator, "Code Assistant", 
        "You are a coding assistant. Help users write, review, and debug code.");
    defer code_agent.deinit();
    
    try stdout.writeAll("   💻 Created: Code Assistant\n");
    try stdout.writeAll("   🐛 Role: Code writing, review, and debugging\n");
    
    try code_agent.execute();
    const code_stats = code_agent.getStats();
    try stdout.print("   ✅ Completed in {d:.2} ms\n", .{code_stats.getExecutionTimeMs()});
    
    // Demo 3: Creative Writing Agent
    try stdout.writeAll("\n3️⃣ Creative Writing Agent\n");
    try stdout.writeAll("=========================\n");
    
    var writing_agent = try nen.createAgentFlow(allocator, "Creative Writer", 
        "You are a creative writing assistant. Help users craft stories, poems, and content.");
    defer writing_agent.deinit();
    
    try stdout.writeAll("   ✍️ Created: Creative Writer\n");
    try stdout.writeAll("   📖 Role: Storytelling and content creation\n");
    
    try writing_agent.execute();
    const writing_stats = writing_agent.getStats();
    try stdout.print("   ✅ Completed in {d:.2} ms\n", .{writing_stats.getExecutionTimeMs()});
    
    // Demo 4: Business Analyst Agent
    try stdout.writeAll("\n4️⃣ Business Analyst Agent\n");
    try stdout.writeAll("==========================\n");
    
    var business_agent = try nen.createAgentFlow(allocator, "Business Analyst", 
        "You are a business analyst. Help users analyze data and make business decisions.");
    defer business_agent.deinit();
    
    try stdout.writeAll("   📊 Created: Business Analyst\n");
    try stdout.writeAll("   💼 Role: Data analysis and business insights\n");
    
    try business_agent.execute();
    const business_stats = business_agent.getStats();
    try stdout.print("   ✅ Completed in {d:.2} ms\n", .{business_stats.getExecutionTimeMs()});
    
    // Performance Summary
    try stdout.writeAll("\n📊 Performance Summary\n");
    try stdout.writeAll("=====================\n");
    
    const total_agents = 4;
    const total_time = research_stats.getExecutionTimeMs() + 
                      code_stats.getExecutionTimeMs() + 
                      writing_stats.getExecutionTimeMs() + 
                      business_stats.getExecutionTimeMs();
    
    try stdout.print("   • Total agents: {d}\n", .{total_agents});
    try stdout.print("   • Total execution time: {d:.2} ms\n", .{total_time});
    try stdout.print("   • Average per agent: {d:.2} ms\n", .{total_time / total_agents});
    try stdout.print("   • Throughput: {d:.0} agents/sec\n", .{1000.0 / (total_time / total_agents)});
    
    try stdout.writeAll("\n🎯 Agent Capabilities Demonstrated:\n");
    try stdout.writeAll("   • Research and information gathering\n");
    try stdout.writeAll("   • Code assistance and debugging\n");
    try stdout.writeAll("   • Creative writing and content generation\n");
    try stdout.writeAll("   • Business analysis and decision support\n");
    
    try stdout.writeAll("\n🚀 NenFlow agents are ready for production use!\n");
    try stdout.writeAll("💡 Each agent can be customized with specific tools and instructions\n");
}
