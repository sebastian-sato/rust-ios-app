# rust-ios-app
Simple iOS app with a Rust backend, primarily for my own future reference.

**Purpose**

I made this app with the intention of using it at my old packaging gig to help me improve and meet the quota, but also serves as a reference for myself on both creating iOS apps and creating/integrating Rust static libraries.

The library is current built against the x86 architecture for testing on my older computer. If you wanted to run this on your computer for some reason, you'd likely need to switch to aarch64

```
cargo build --target aarch64-apple-ios
```

or for the simulator:
```
cargo build --target aarch64-apple-ios-sim
```

<img src='./Screenshot%202026-10-15%20at%202.16.20%20PM.png' width=60%>
