# System Architecture
The system uses a "Meta-Orchestrator" framework (The Digital Assembly Line) to manage specialist agents. 

## Flow
1. User input hits the **Supervisor Agent**.
2. Supervisor breaks down constraints and budget.
3. Supervisor delegates to **Flight Broker**, **Lodging Broker**, and **Concierge** in sequence or parallel as needed.
4. Supervisor compiles results, verifies constraints, and returns final itinerary.
