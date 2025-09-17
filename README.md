# 🚀 NenDB - AI-Native Graph Database

> **Lightning-fast graph database built with Data-Oriented Design (DOD) for AI workloads** ⚡

[![Zig](https://img.shields.io/badge/Zig-0.15.1-F7A41D)](https://ziglang.org/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Version](https://img.shields.io/badge/Version-v0.2.1--beta-green.svg)](https://github.com/Nen-Co/nen-db/releases)
[![NPM](https://img.shields.io/badge/NPM-@nenco%2Fnendb-red.svg)](https://www.npmjs.com/package/@nenco/nendb)
[![Bun](https://img.shields.io/badge/Bun-1.2.19-000000.svg)](https://bun.sh/)
[![DOD](https://img.shields.io/badge/Architecture-Data--Oriented--Design-FF6B6B)](docs/DATA_ORIENTED_DESIGN.md)

## 📦 **Package Structure**

NenDB is now split into **optimized packages** to eliminate bloat:

### 🌐 **@nenco/nendb-wasm** - WebAssembly Version
```bash
# NPM
npm install @nenco/nendb-wasm
# or (shorthand)
npm i @nenco/nendb-wasm

# Bun (Recommended)
bun add @nenco/nendb-wasm
```
- **Size**: ~54KB (vs 19MB for full package)
- **Use case**: Browser applications, Node.js WASM
- **Features**: WebAssembly, browser-compatible, TypeScript support, Bun optimized
- **CLI**: `npx nendb-wasm help` or `bunx nendb-wasm help` (package exposes the `nendb-wasm` CLI)

### 🖥️ **@nenco/nendb-native** - Native Version  
```bash
# NPM
npm install @nenco/nendb-native
# or (shorthand)
npm i @nenco/nendb-native

# Bun (Recommended)
bun add @nenco/nendb-native
```
- **Size**: ~50MB (platform-specific binaries)
- **Use case**: Server applications, high-performance computing
- **Features**: Native performance, SIMD optimization, full API, Bun optimized
- **CLI**: `npx nendb-create help` or `bunx nendb-create help` (package exposes the `nendb-create` CLI)

### 🔄 **@nenco/nendb** - Meta Package (Deprecated)
```bash
npm install @nenco/nendb  # ⚠️ Use specific packages instead
# or (shorthand)
npm i @nenco/nendb
```
- **Size**: 19MB (includes all platforms - bloated!)
- **Status**: Deprecated - use specific packages above

## 🎯 **Quick Start**

### **For Browser/WebAssembly:**
```bash
# Bun (Recommended)
bun add @nenco/nendb-wasm

# Or with NPM
npm install @nenco/nendb-wasm
```

```javascript
// ES Modules (Bun/Node.js)
import nendb from '@nenco/nendb-wasm';

// CommonJS (Node.js)
const nendb = require('@nenco/nendb-wasm');

// Initialize WASM database (async init may be required)
const db = await nendb.init();
await db.createNode({ id: 1, type: 'user', name: 'Alice' });
await db.createEdge({ from: 1, to: 2, type: 'follows' });
```

### **For Server/Native:**
```bash
# Bun (Recommended)
bun add @nenco/nendb-native

# Or with NPM
npm install @nenco/nendb-native
```

```javascript
// ES Modules (Bun/Node.js)
import nendb from '@nenco/nendb-native';

// CommonJS (Node.js)
const nendb = require('@nenco/nendb-native');

// Initialize native database (synchronous API exposed by native package)
const db = nendb.init();
db.createNode({ id: 1, type: 'user', name: 'Alice' });
db.createEdge({ from: 1, to: 2, type: 'follows' });
```

## ✨ **Key Features**

### 🎨 **Core Capabilities**
- **Data-Oriented Design**: Struct of Arrays (SoA) layout for maximum performance
- **Component System**: Entity-component architecture for flexible data modeling
- **SIMD Operations**: Vectorized processing for peak throughput
- **Static Memory Pools**: Predictable performance with configurable memory limits
- **Write-Ahead Logging**: Crash-safe persistence with point-in-time recovery
- **Graph Algorithms**: BFS, Dijkstra, PageRank, and Community Detection
- **HTTP API**: RESTful interface using nen-net networking framework
- **CLI Interface**: Command-line tools for database management

### 🚀 **Performance Features**
- **Cache Locality**: SoA layout optimizes memory access patterns
- **SIMD Optimization**: Vectorized operations on aligned data structures
- **Hot/Cold Separation**: Frequently accessed data separated from cold data
- **Memory Pools**: Static allocation for zero GC overhead
- **Predictable Latency**: Consistent response times under load
- **Efficient Storage**: DOD-optimized data structures for graph operations
- **Cross-Platform**: Linux, macOS, and Windows support

### 🍞 **Bun Integration**
- **Native Bun Support**: Optimized for Bun runtime
- **Faster Installation**: Bun's fast package manager
- **Better Performance**: Bun's JavaScript engine optimizations
- **Smaller Bundles**: Bun's efficient bundling
- **TypeScript First**: Native TypeScript support

## 🛠️ **CLI Commands**

### **WASM Commands:**
```bash
# Install WASM package
bun add @nenco/nendb-wasm

# Available commands (the package exposes a `nendb-wasm` CLI)
bunx nendb-wasm help
bunx nendb-wasm create my-database
bunx nendb-wasm serve 8080
bunx nendb-wasm test
bunx nendb-wasm info

# Or with NPM (npx will run the `nendb-wasm` binary)
npx nendb-wasm help
```

### **Native Commands:**
```bash
# Install native package
bun add @nenco/nendb-native

# Available commands (the package exposes a `nendb-create` CLI)
bunx nendb-create help
bunx nendb-create init my-database
bunx nendb-create server --port 8080

# Or with NPM
npx nendb-create help
```

## 📊 **Performance Comparison**

| **Metric** | **WASM** | **Native** | **Meta Package** |
|------------|----------|------------|------------------|
| **Package Size** | 54KB | 50MB | 19MB |
| **Performance** | 80% | 100% | 100% |
| **Browser Support** | ✅ | ❌ | ❌ |
| **Node.js Support** | ✅ | ✅ | ✅ |
| **Bun Support** | ✅ | ✅ | ✅ |
| **Memory Usage** | Low | Medium | High |
| **Installation Speed** | ⚡ Fast | ⚡ Fast | 🐌 Slow |

## 🔌 **API Endpoints**

### **HTTP API (Native only)**
- `GET /health` - Server health check
- `GET /graph/stats` - Graph statistics
- `POST /graph/algorithms/bfs` - Breadth-first search
- `POST /graph/algorithms/dijkstra` - Shortest path
- `POST /graph/algorithms/pagerank` - PageRank centrality
- `POST /graph/algorithms/community` - Community detection

## 🏗️ **Architecture**

### **Data-Oriented Design (DOD)**
```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Node Arrays   │    │   Edge Arrays   │    │ Component Arrays│
│                 │    │                 │    │                 │
│ id: [1,2,3...]  │    │ from: [1,2...]  │    │ name: ["A"...]  │
│ type: [1,1...]  │    │ to: [2,3...]    │    │ age: [25,30...] │
│ data: [ptr...]  │    │ label: [1,2...] │    │ score: [0.8...] │
└─────────────────┘    └─────────────────┘    └─────────────────┘
```

### **Memory Layout**
- **Hot Data**: Frequently accessed nodes and edges
- **Cold Data**: Historical data and metadata
- **SIMD Aligned**: 32-byte alignment for vector operations
- **Cache Friendly**: Sequential access patterns

## 🚀 **Installation**

### **Choose Your Package:**

#### **For Web Applications:**
```bash
# Bun (Recommended)
bun add @nenco/nendb-wasm

# NPM
npm install @nenco/nendb-wasm
```

#### **For Server Applications:**
```bash
# Bun (Recommended)
bun add @nenco/nendb-native

# NPM
npm install @nenco/nendb-native
```

#### **For Development (All Platforms):**
```bash
git clone https://github.com/Nen-Co/nen-db.git
cd nen-db
zig build --release=fast
```

## 📚 **Examples**

### **WASM Example (Browser):**
```html
<!DOCTYPE html>
<html>
<head>
    <script type="module">
        import nendb from '@nenco/nendb-wasm';
        
        async function init() {
            const db = await nendb.init();
            await db.createNode({ id: 1, type: 'user', name: 'Alice' });
            console.log('Node created!');
        }
        
        init();
    </script>
</head>
<body>
    <h1>NenDB WASM Demo</h1>
</body>
</html>
```

### **Native Example (Bun):**
```javascript
// bun example.js
import nendb from '@nenco/nendb-native';

// Initialize database
const db = nendb.init();

// Create nodes
db.createNode({ id: 1, type: 'user', name: 'Alice' });
db.createNode({ id: 2, type: 'user', name: 'Bob' });

// Create edge
db.createEdge({ from: 1, to: 2, type: 'follows' });

// Run algorithm
const path = db.shortestPath(1, 2);
console.log('Shortest path:', path);
```

### **Native Example (Node.js):**
```javascript
const nendb = require('@nenco/nendb-native');

// Initialize database
const db = nendb.init();

// Create nodes
db.createNode({ id: 1, type: 'user', name: 'Alice' });
db.createNode({ id: 2, type: 'user', name: 'Bob' });

// Create edge
db.createEdge({ from: 1, to: 2, type: 'follows' });

// Run algorithm
const path = db.shortestPath(1, 2);
console.log('Shortest path:', path);
```

## 🤝 **Contributing**

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

### **Development Setup:**
```bash
git clone https://github.com/Nen-Co/nen-db.git
cd nen-db

# Build native version
zig build --release=fast

# Build WASM version
zig build wasm --release=small

# Run tests
zig build test

# Publish packages (Bun)
./scripts/publish-bun.sh

# Publish packages (NPM)
./scripts/publish-packages.sh
```

## 📄 **License**

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 **Acknowledgments**

- **TigerBeetle** - Inspiration for high-performance batching patterns
- **Zig Community** - For the excellent language and ecosystem
- **Bun Team** - For the fast JavaScript runtime and package manager
- **Data-Oriented Design** - For performance optimization principles

## 📞 **Support**

- **Issues**: [GitHub Issues](https://github.com/Nen-Co/nen-db/issues)
- **Discussions**: [GitHub Discussions](https://github.com/Nen-Co/nen-db/discussions)
- **Documentation**: [API Docs](https://nen.co/docs)

---

**Built with ❤️ for high-performance computing in Zig + Bun**

## 🎯 **Migration Guide**

### **From @nenco/nendb to specific packages:**

#### **For Browser Applications:**
```bash
# Old
npm install @nenco/nendb
import nendb from '@nenco/nendb/wasm';

# New (Bun - Recommended)
bun add @nenco/nendb-wasm
import nendb from '@nenco/nendb-wasm';

# New (NPM)
npm install @nenco/nendb-wasm
import nendb from '@nenco/nendb-wasm';
```

#### **For Server Applications:**
```bash
# Old
npm install @nenco/nendb
const nendb = require('@nenco/nendb');

# New (Bun - Recommended)
bun add @nenco/nendb-native
import nendb from '@nenco/nendb-native';

# New (NPM)
npm install @nenco/nendb-native
const nendb = require('@nenco/nendb-native');
```

**Benefits of Migration:**
- ✅ **99.7% smaller package size** (54KB vs 19MB)
- ✅ **Faster installation** (Bun is 3-5x faster than NPM)
- ✅ **Platform-specific optimization**
- ✅ **Reduced bandwidth usage**
- ✅ **Better tree-shaking**
- ✅ **Bun runtime optimizations**

## 🍞 **Why Bun?**

- **⚡ Speed**: 3-5x faster package installation than NPM
- **🚀 Performance**: Optimized JavaScript engine
- **📦 Efficiency**: Better compression and bundling
- **🔧 Developer Experience**: Built-in TypeScript support
- **🌐 Compatibility**: Works with existing NPM packages
- **🛠️ Tooling**: Integrated bundler, test runner, and package manager
