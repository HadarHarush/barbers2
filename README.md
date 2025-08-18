# Barber Booking App

A **mobile** appointment booking app for a single barber shop, built with **Flutter** (iOS + Android).
During development we **always run on the iPhone 16 Simulator** (Xcode is already installed; no extra setup needed).

> **Stage 0 scope:** **Frontend only** with mocked data.  
> We will iterate on the **UX/UI first**, learn from what feels wrong, fix it, and only after the frontend is stable we will connect a backend + database (**Supabase** planned).

---

## 📚 UX Specification (Single Source of Truth)

- The complete UX spec is in **[UX.md](./UX.md)**.  
- **Do not implement flows that are not defined there.**  
- `UX.md` includes a Hebrew summary (for reading only) **and** the full English spec (for development).

### 🔁 When UX decisions change
**Always follow this order:**
1. **Edit `UX.md` first** – update the spec (English section).  
2. **Version & log** – add a short “Changelog” entry at the bottom of `UX.md` with date + summary of changes.  
3. **Implement in code** – update Flutter screens/widgets to match the new spec.  
4. **Test on iPhone 16 Simulator** – verify the new flow end-to-end.  
5. **Commit** – include `UX.md` changes in the same commit with a clear message, e.g.:  
