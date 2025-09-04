// Nen Framework Data-Oriented Design (DOD) Configuration
// Optimized for high-performance LLM workflow execution with static memory management

const std = @import("std");

// DOD Configuration for nen framework
pub const DODConfig = struct {
    // Node configuration
    pub const nodes = struct {
        pub const max_nodes: u32 = 1024; // Maximum nodes per flow
        pub const max_node_id_size: u32 = 64; // Max node ID size
        pub const max_node_data_size: u32 = 1024; // Max node data size
        pub const alignment: u32 = 64; // Cache line alignment
        pub const simd_alignment: u32 = 32; // SIMD alignment
    };
    
    // Flow configuration
    pub const flows = struct {
        pub const max_flows: u32 = 256; // Maximum concurrent flows
        pub const max_flow_id_size: u32 = 32; // Max flow ID size
        pub const max_dependencies: u32 = 16; // Max dependencies per node
        pub const max_parallel_nodes: u32 = 32; // Max parallel execution
    };
    
    // Execution configuration
    pub const execution = struct {
        pub const max_execution_time_ms: u64 = 30000; // 30 seconds max
        pub const default_timeout_ms: u64 = 5000; // 5 seconds default
        pub const max_retries: u32 = 3; // Maximum retry attempts
        pub const batch_size: u32 = 8; // Batch processing size
        pub const parallel_execution: bool = true; // Enable parallel execution
    };
    
    // Prefetching configuration
    pub const prefetching = struct {
        pub const enable_hardware_prefetch: bool = true;
        pub const enable_software_prefetch: bool = true;
        pub const prefetch_distance: u32 = 2; // Cache lines ahead
        pub const max_prefetch_requests: u32 = 8; // Maximum concurrent prefetch requests
        pub const node_prefetch_size: u32 = 16; // Node prefetch size in KB
        pub const flow_prefetch_size: u32 = 32; // Flow prefetch size in KB
    };
    
    // SIMD configuration
    pub const simd = struct {
        pub const enable_simd: bool = true;
        pub const simd_width: u32 = 8; // SIMD width for vectorized operations
        pub const alignment: u32 = 32; // SIMD alignment requirement
        pub const batch_size: u32 = 8; // Process 8 elements at once
        pub const node_simd_batch: u32 = 8; // SIMD batch for node operations
        pub const flow_simd_batch: u32 = 8; // SIMD batch for flow operations
    };
    
    // Memory pools configuration
    pub const memory_pools = struct {
        pub const node_pool_size: u32 = 512; // Node pool size
        pub const flow_pool_size: u32 = 128; // Flow pool size
        pub const execution_pool_size: u32 = 64; // Execution pool size
        pub const stats_pool_size: u32 = 32; // Statistics pool size
        pub const prefetch_pool_size: u32 = 16; // Prefetch pool size
    };
    
    // Performance targets
    pub const performance = struct {
        pub const min_throughput_flows_s: f64 = 1000.0; // Target: 1000 flows/second
        pub const max_latency_ms: u64 = 1; // Target: <1ms latency
        pub const node_execution_time_ns: u64 = 1000; // Target: <1μs node execution
        pub const cache_hit_rate: f64 = 0.95; // Target: >95% cache hit rate
        pub const memory_efficiency: f64 = 0.9; // Target: >90% memory efficiency
        pub const simd_utilization: f64 = 0.8; // Target: >80% SIMD utilization
        pub const parallel_efficiency: f64 = 0.85; // Target: >85% parallel efficiency
    };
    
    // Feature flags
    pub const features = struct {
        pub const use_soa_layout: bool = true; // Use Struct of Arrays layout
        pub const separate_hot_cold: bool = true; // Separate hot and cold data
        pub const enable_component_system: bool = true; // Enable component-based architecture
        pub const align_for_simd: bool = true; // Align data for SIMD operations
        pub const use_memory_pools: bool = true; // Use static memory pools
        pub const enable_memory_prefetch: bool = true; // Enable memory prefetching
        pub const enable_vectorization: bool = true; // Enable vectorized operations
        pub const enable_batch_processing: bool = true; // Enable batch processing
        pub const optimize_cache_locality: bool = true; // Optimize for cache locality
        pub const use_cache_friendly_layouts: bool = true; // Use cache-friendly layouts
        pub const enable_parallel_execution: bool = true; // Enable parallel execution
        pub const enable_workflow_prefetch: bool = true; // Enable workflow prefetching
    };
};

// DOD-specific constants
pub const DOD_CONSTANTS = struct {
    // Node sizes (power of 2 for better alignment)
    pub const NODE_SIZE_SMALL = 64; // 64 bytes
    pub const NODE_SIZE_MEDIUM = 256; // 256 bytes
    pub const NODE_SIZE_LARGE = 1024; // 1KB
    pub const NODE_SIZE_HUGE = 4096; // 4KB
    
    // Alignment requirements
    pub const CACHE_LINE_SIZE = 64;
    pub const SIMD_ALIGNMENT = 32;
    pub const PAGE_SIZE = 4096;
    
    // Pool sizes
    pub const MAX_NODES = 1024; // 1K nodes
    pub const MAX_FLOWS = 256; // 256 flows
    pub const MAX_EXECUTIONS = 128; // 128 executions
    pub const MAX_STATS = 64; // 64 stats entries
    pub const MAX_PREFETCH = 32; // 32 prefetch entries
    pub const MAX_DEPENDENCIES = 16; // 16 dependencies per node
    pub const MAX_FLOW_ID_SIZE = 32; // 32 bytes for flow ID
    
    // SIMD batch sizes
    pub const SIMD_NODE_BATCH = 8;
    pub const SIMD_FLOW_BATCH = 8;
    pub const SIMD_EXECUTION_BATCH = 8;
    pub const SIMD_STATS_BATCH = 8;
    
    // Prefetch distances
    pub const PREFETCH_DISTANCE_SMALL = 1;
    pub const PREFETCH_DISTANCE_MEDIUM = 2;
    pub const PREFETCH_DISTANCE_LARGE = 4;
    
    // Performance thresholds
    pub const THROUGHPUT_THRESHOLD_FLOWS_S = 100.0;
    pub const LATENCY_THRESHOLD_MS = 10;
    pub const CACHE_HIT_THRESHOLD = 0.9;
    pub const MEMORY_EFFICIENCY_THRESHOLD = 0.8;
};

// DOD error types
pub const DODError = error{
    PoolExhausted,
    NodeOverflow,
    FlowOverflow,
    InvalidAlignment,
    PrefetchFailed,
    SIMDNotSupported,
    ComponentNotFound,
    HotColdSeparationFailed,
    SoALayoutError,
    MemoryPoolError,
    ExecutionError,
    ParallelExecutionError,
};

// DOD statistics
pub const DODStats = struct {
    // Performance metrics
    throughput_flows_s: f64 = 0.0,
    latency_ms: f64 = 0.0,
    node_execution_time_ns: f64 = 0.0,
    cache_hit_rate: f64 = 0.0,
    memory_efficiency: f64 = 0.0,
    simd_utilization: f64 = 0.0,
    parallel_efficiency: f64 = 0.0,
    
    // Operation counts
    node_operations: u64 = 0,
    flow_operations: u64 = 0,
    execution_operations: u64 = 0,
    prefetch_operations: u64 = 0,
    simd_operations: u64 = 0,
    parallel_operations: u64 = 0,
    
    // Prefetch statistics
    hardware_prefetches: u64 = 0,
    software_prefetches: u64 = 0,
    prefetch_hits: u64 = 0,
    prefetch_misses: u64 = 0,
    workflow_prefetches: u64 = 0,
    
    // Memory statistics
    total_allocated: u64 = 0,
    total_freed: u64 = 0,
    peak_usage: u64 = 0,
    current_usage: u64 = 0,
    pool_usage: [4]u64 = [_]u64{0} ** 4,
    
    // Execution statistics
    successful_executions: u64 = 0,
    failed_executions: u64 = 0,
    retry_attempts: u64 = 0,
    timeout_occurrences: u64 = 0,
    
    pub fn getThroughput(self: DODStats) f64 {
        return self.throughput_flows_s;
    }
    
    pub fn getLatency(self: DODStats) f64 {
        return self.latency_ms;
    }
    
    pub fn getNodeExecutionTime(self: DODStats) f64 {
        return self.node_execution_time_ns;
    }
    
    pub fn getCacheHitRate(self: DODStats) f64 {
        return self.cache_hit_rate;
    }
    
    pub fn getMemoryEfficiency(self: DODStats) f64 {
        return self.memory_efficiency;
    }
    
    pub fn getSIMDUtilization(self: DODStats) f64 {
        return self.simd_utilization;
    }
    
    pub fn getParallelEfficiency(self: DODStats) f64 {
        return self.parallel_efficiency;
    }
    
    pub fn getTotalOperations(self: DODStats) u64 {
        return self.node_operations + self.flow_operations + 
               self.execution_operations + self.prefetch_operations + 
               self.simd_operations + self.parallel_operations;
    }
    
    pub fn getExecutionSuccessRate(self: DODStats) f64 {
        const total_executions = self.successful_executions + self.failed_executions;
        if (total_executions == 0) return 0.0;
        return @as(f64, @floatFromInt(self.successful_executions)) / @as(f64, @floatFromInt(total_executions));
    }
    
    pub fn getPoolUtilization(self: DODStats, pool: u32) f64 {
        if (pool >= 4) return 0.0;
        const total_pool_usage = self.pool_usage[0] + self.pool_usage[1] + 
                                self.pool_usage[2] + self.pool_usage[3];
        if (total_pool_usage == 0) return 0.0;
        return @as(f64, @floatFromInt(self.pool_usage[pool])) / @as(f64, @floatFromInt(total_pool_usage));
    }
    
    pub fn getMemoryUtilization(self: DODStats) f64 {
        if (self.peak_usage == 0) return 0.0;
        return @as(f64, @floatFromInt(self.current_usage)) / @as(f64, @floatFromInt(self.peak_usage));
    }
};
