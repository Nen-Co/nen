const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    // Main library (for Zig usage)
    const lib = b.createModule(.{
        .root_source_file = b.path("src/lib.zig"),
        .target = target,
        .optimize = optimize,
    });

    // Main executable
    const exe = b.addExecutable(.{
        .name = "nen",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });

    exe.root_module.addImport("nen", lib);
    b.installArtifact(exe);

    // Unit tests
    const unit_tests = b.addTest(.{
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/lib.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });

    unit_tests.root_module.addImport("nen", lib);
    const run_unit_tests = b.addRunArtifact(unit_tests);

    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_unit_tests.step);

    // Simple examples
    const basic_example = b.addExecutable(.{
        .name = "basic-example",
        .root_module = b.createModule(.{
            .root_source_file = b.path("examples/basic_agent.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });
    basic_example.root_module.addImport("nen", lib);

    const run_basic_example = b.addRunArtifact(basic_example);
    const basic_example_step = b.step("basic-example", "Run basic agent example");
    basic_example_step.dependOn(&run_basic_example.step);

    // All examples step
    const examples_step = b.step("examples", "Run all examples");
    examples_step.dependOn(basic_example_step);

    // Development step
    const dev_step = b.step("dev", "Run development tools");
    dev_step.dependOn(test_step);
    dev_step.dependOn(examples_step);
}
