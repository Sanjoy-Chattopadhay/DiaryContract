# 🗒️ DiaryContract

A decentralized personal diary built on Ethereum using Solidity. Users can create, manage, and comment on diary entries with privacy controls, timestamps, and soft deletion support.

---

## 🚀 Features

- ✍️ **Create Entries** — Add personal notes with public/private visibility.
- 🧾 **Commenting System** — Users can comment on public entries.
- 🔐 **Access Control** — Allow others to write entries on your behalf.
- ❌ **Soft Delete** — Delete entries without removing them from storage.
- 📅 **Timestamp Filtering** — Fetch entries between specific date ranges.

---

## 🛠️ Tech Stack

- **Solidity**
- **Ethereum Virtual Machine**
- **Remix / Hardhat / Foundry** (for local development)

---

## 📄 Smart Contract Overview

### Structs

- `Entry`: Represents a diary entry.
- `Comment`: Represents a comment on an entry.

### Mappings

- `entries`: Maps entry ID to `Entry`.
- `comments`: Maps entry ID to an array of `Comment`.
- `entriesOf`: Maps user address to their entry IDs.
- `editors`: Grants write access to another address.

### Core Functions

\`\`\`solidity
addEntry(string memory title, string memory content, bool isPublic)
addEntryFor(address owner, string memory title, string memory content, bool isPublic)
deleteEntry(uint entryId)
addComment(uint entryId, string memory message)
getLatestEntries(address user, uint count) view returns (Entry[])
getEntriesBetween(address user, uint start, uint end) view returns (Entry[])
\`\`\`

---

## 🔐 Access Control

Allow someone to write entries for you:

\`\`\`solidity
allowEditor(address editor)
disallowEditor(address editor)
\`\`\`

---

## 💡 Example Use Cases

- Keep a **public blog** or a **private journal** on-chain.
- Let collaborators or assistants write on your behalf.
- Allow public **reactions** via comments.
- Use timestamps to query entries like "My June diary".

---

## 📦 Deployment

You can deploy this smart contract using:

- [Remix IDE](https://remix.ethereum.org/)
- Hardhat / Truffle CLI
- Injected Web3 (e.g., MetaMask)

---

## 🧪 Testing

To test:

- Add entries (public & private)
- Comment as another user
- Use \`getEntriesBetween()\` with different timestamps

---
