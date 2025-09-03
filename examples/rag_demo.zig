const std = @import("std");
const nen = @import("nen");

pub fn main() !void {
    const stdout = std.io.getStdOut().writer();

    try stdout.writeAll("🔍 NenFlow RAG (Retrieval-Augmented Generation) Demo\n");
    try stdout.writeAll("==================================================\n\n");

    const allocator = std.heap.page_allocator;

    // Demo 1: Technical Documentation RAG
    try stdout.writeAll("1️⃣ Technical Documentation RAG\n");
    try stdout.writeAll("================================\n");

    const tech_query = "What are the benefits of using Zig for systems programming?";
    var tech_rag = try nen.createRAGFlow(allocator, tech_query);
    defer tech_rag.deinit();

    try stdout.writeAll("   🔍 Query: What are the benefits of using Zig for systems programming?\n");
    try stdout.writeAll("   📚 RAG nodes: Query → Retrieval → LLM Generation\n");

    try tech_rag.execute();
    const tech_stats = tech_rag.getStats();
    try stdout.print("   ✅ Completed in {d:.2} ms\n", .{tech_stats.getExecutionTimeMs()});

    // Demo 2: Research Paper RAG
    try stdout.writeAll("\n2️⃣ Research Paper RAG\n");
    try stdout.writeAll("=====================\n");

    const research_query = "What are the latest developments in large language models?";
    var research_rag = try nen.createRAGFlow(allocator, research_query);
    defer research_rag.deinit();

    try stdout.writeAll("   🔍 Query: What are the latest developments in large language models?\n");
    try stdout.writeAll("   📚 RAG nodes: Query → Retrieval → LLM Generation\n");

    try research_rag.execute();
    const research_stats = research_rag.getStats();
    try stdout.print("   ✅ Completed in {d:.2} ms\n", .{research_stats.getExecutionTimeMs()});

    // Demo 3: Business Intelligence RAG
    try stdout.writeAll("\n3️⃣ Business Intelligence RAG\n");
    try stdout.writeAll("=============================\n");

    const business_query = "What are the key trends in AI adoption in enterprise software?";
    var business_rag = try nen.createRAGFlow(allocator, business_query);
    defer business_rag.deinit();

    try stdout.writeAll("   🔍 Query: What are the key trends in AI adoption in enterprise software?\n");
    try stdout.writeAll("   📚 RAG nodes: Query → Retrieval → LLM Generation\n");

    try business_rag.execute();
    const business_stats = business_rag.getStats();
    try stdout.print("   ✅ Completed in {d:.2} ms\n", .{business_stats.getExecutionTimeMs()});

    // Demo 4: Creative Content RAG
    try stdout.writeAll("\n4️⃣ Creative Content RAG\n");
    try stdout.writeAll("========================\n");

    const creative_query = "How can I write compelling science fiction stories?";
    var creative_rag = try nenflow.createRAGFlow(allocator, creative_query);
    defer creative_rag.deinit();

    try stdout.writeAll("   🔍 Query: How can I write compelling science fiction stories?\n");
    try stdout.writeAll("   📚 RAG nodes: Query → Retrieval → LLM Generation\n");

    try creative_rag.execute();
    const creative_stats = creative_rag.getStats();
    try stdout.print("   ✅ Completed in {d:.2} ms\n", .{creative_stats.getExecutionTimeMs()});

    // Performance Summary
    try stdout.writeAll("\n📊 RAG Performance Summary\n");
    try stdout.writeAll("==========================\n");

    const total_rag_flows = 4;
    const total_time = tech_stats.getExecutionTimeMs() +
        research_stats.getExecutionTimeMs() +
        business_stats.getExecutionTimeMs() +
        creative_stats.getExecutionTimeMs();

    try stdout.print("   • Total RAG flows: {d}\n", .{total_rag_flows});
    try stdout.print("   • Total execution time: {d:.2} ms\n", .{total_time});
    try stdout.print("   • Average per RAG flow: {d:.2} ms\n", .{total_time / total_rag_flows});
    try stdout.print("   • Throughput: {d:.0} RAG flows/sec\n", .{1000.0 / (total_time / total_rag_flows)});

    try stdout.writeAll("\n🎯 RAG Capabilities Demonstrated:\n");
    try stdout.writeAll("   • Technical documentation search and Q&A\n");
    try stdout.writeAll("   • Research paper analysis and summarization\n");
    try stdout.writeAll("   • Business intelligence and trend analysis\n");
    try stdout.writeAll("   • Creative content generation and guidance\n");

    try stdout.writeAll("\n🔍 RAG Workflow Components:\n");
    try stdout.writeAll("   • Query Processing: Natural language understanding\n");
    try stdout.writeAll("   • Information Retrieval: Relevant document search\n");
    try stdout.writeAll("   • Context Enhancement: Augmenting with retrieved information\n");
    try stdout.writeAll("   • LLM Generation: Context-aware response generation\n");

    try stdout.writeAll("\n🚀 NenFlow RAG is production-ready!\n");
    try stdout.writeAll("💡 Perfect for knowledge bases, documentation, and research applications\n");
}
