
<p align="center">
   <picture>
      <source media="(prefers-color-scheme: dark)" srcset="packages/console/app/src/asset/brand/deeprise-white-png.png">
      <img alt="DeepRise logo" src="packages/console/app/src/asset/brand/deeprise-black-png.png" width="240">
   </picture>
</p>

# Open-source long-running coding agents that work in parallel

DeepRise is a multi-agent system that autonomously plans, builds, tests, and improves software using long-running AI agents working in parallel.

![DeepRise Demo](demo/sample.png)
![DeepRise Structure](demo/agent_chart_arch.jpg)

---

## Example of Agents

1. **Super Agent**: Acts as the manager of all the agents
2. **Orchestration Agent**: Designs software architecture
3. **Developer Agent**: Implements features and writes code
4. **Test Agent**: Creates and runs tests

And many more...

---

## Installation

Choose the setup that fits your workflow:

1. **Install from the hosted installer**

   ```bash
   curl -fsSL https://deeprise.dev/install | bash
   ```

2. **Install from a local clone**

   ```bash
   git clone https://github.com/MehdiGhorb/deeprise.git
   cd deeprise
   bash install
   # or: bash install --local for installation from local repo
   ```

---

## Acknowledgments

See [ACKNOWLEDGMENTS.md](ACKNOWLEDGMENTS.md) for the full acknowledgments note.