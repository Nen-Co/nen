#!/usr/bin/env python3
"""
Python binding example for Nen LLM Framework
Shows how the minimal Zig library can be used from Python
"""

import ctypes
from ctypes import c_int, c_char_p, c_void_p
import time

# Load the Zig library
try:
    nen_lib = ctypes.CDLL("./zig-out/lib/libnen.dylib")  # macOS
except:
    try:
        nen_lib = ctypes.CDLL("./zig-out/lib/libnen.so")  # Linux
    except:
        nen_lib = ctypes.CDLL("./zig-out/lib/nen.dll")    # Windows

# Define function signatures
nen_lib.nen_create_agent_flow.argtypes = [c_void_p, c_char_p, c_char_p]
nen_lib.nen_create_agent_flow.restype = c_void_p

nen_lib.nen_execute_flow.argtypes = [c_void_p]
nen_lib.nen_execute_flow.restype = c_int

nen_lib.nen_get_flow_stats.argtypes = [c_void_p]
nen_lib.nen_get_flow_stats.restype = c_void_p

class NenFlow:
    """Python wrapper for Nen LLM Framework"""
    
    def __init__(self):
        self.flows = []
    
    def create_agent(self, name: str, instructions: str):
        """Create an agent flow"""
        print(f"🤖 Creating agent: {name}")
        print(f"📝 Instructions: {instructions}")
        
        # Call Zig library
        flow_ptr = nen_lib.nen_create_agent_flow(
            None,  # allocator (simplified)
            name.encode('utf-8'),
            instructions.encode('utf-8')
        )
        
        if flow_ptr:
            self.flows.append(flow_ptr)
            return flow_ptr
        else:
            raise RuntimeError("Failed to create agent flow")
    
    def execute_flow(self, flow_ptr):
        """Execute a flow"""
        print("🚀 Executing flow...")
        start_time = time.time()
        
        result = nen_lib.nen_execute_flow(flow_ptr)
        
        if result == 0:
            duration = (time.time() - start_time) * 1000
            print(f"✅ Flow completed in {duration:.2f} ms")
            return True
        else:
            print("❌ Flow execution failed")
            return False
    
    def get_stats(self, flow_ptr):
        """Get flow statistics"""
        stats_ptr = nen_lib.nen_get_flow_stats(flow_ptr)
        if stats_ptr:
            # In a real implementation, you'd extract the stats structure
            print("📊 Flow statistics retrieved")
            return {"status": "success"}
        else:
            return {"status": "failed"}

def main():
    """Demo of Python binding usage"""
    print("🚀 Nen: Minimalist LLM Framework - Python Binding Demo")
    print("=" * 60)
    
    # Create Nen wrapper
    nen = NenFlow()
    
    # Demo 1: Create and execute an agent
    print("\n1️⃣ Agent Demo")
    print("-" * 20)
    
    agent_flow = nen.create_agent(
        "Research Assistant",
        "You are a research assistant. Help users find information and answer questions."
    )
    
    success = nen.execute_flow(agent_flow)
    if success:
        stats = nen.get_stats(agent_flow)
        print(f"   Stats: {stats}")
    
    # Demo 2: Create multiple agents
    print("\n2️⃣ Multiple Agents Demo")
    print("-" * 30)
    
    agents = [
        ("Code Assistant", "Help with coding and debugging"),
        ("Creative Writer", "Assist with creative writing"),
        ("Business Analyst", "Provide business insights")
    ]
    
    for name, instructions in agents:
        agent = nen.create_agent(name, instructions)
        nen.execute_flow(agent)
        nen.get_stats(agent)
    
    print("\n🎉 Python binding demo completed!")
    print("💡 The Zig library handles all the complex logic")
    print("🐍 Python just calls simple functions")

if __name__ == "__main__":
    main()
