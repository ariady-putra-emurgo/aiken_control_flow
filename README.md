# aiken_control_flow

This project contains:

- Basic control flow showcase at [`./lib/control/flow.ak`](./lib/control/flow.ak):
  - `if-else`
  - `when-is`
- Soft-casting (`if-is`) showcase at [`./validators/advanced.ak`](./validators/advanced.ak) and its comparison to `choose_data` (the old way)

## Activity

Define `fn when_map(_)` that will return `True` when you pass a map containing exactly 1 element of key-value pair where the key is 0 (integer) and the value is 1 (integer), otherwise it will fail.
