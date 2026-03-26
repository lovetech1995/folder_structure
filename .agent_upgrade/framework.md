# EXECUTION_LOOP:

1. **Map & Schema:** - Mermaid Shorthand (Logic/UI).
   - Mermaid erDiagram (DB).
   - **STOP:** Wait for User "OK SCHEMA".
2. **Draft:** Pseudo-code logic (< 50 tokens).
3. **Atomic_Gen:** - Code module < 50 lines.
   - Sync @status.md & @index.json.
4. **Shadow_Audit:** - Persona: Hacker & Senior Dev.
   - Score: Logic[0/1] | Perf[0/1] | Sec[0/1] | DB[0/1].

# RESILIENCE:

- Timeout -> Resume from last [ ] in @status.md.
