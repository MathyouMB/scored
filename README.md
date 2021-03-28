# Scored

Scored is an elixir based web application for holding scrum planning poker 🃏. This application was built to build a deeper understanding of OTP, concurrency, and the Elixir ecosystem. I intentionally built this application without a larger framework like Phoenix so that I would have the chance to implement key OTP concepts on my own.

<hr>

<img src="/documentation/main.png" width="800px">

# Setup

Ensure you have Elixir installed and run the following command to setup project dependencies.

```elixir

mix deps.get

```

Run the following command to run the application.

```elixir

iex -S mix

```

Navigate to `localhost:4000` to view the application.

# Supervision Tree

The following is a simplified representation of the Supervision Tree used in this application.

<img src="/documentation/simplified_supervision_tree.png" width="600px">

# Resources

The following [article](https://medium.com/@loganbbres/elixir-websocket-chat-example-c72986ab5778) was extremely helpful for helping start this project.

# License

MIT. See <a href="https://github.com/MathyouMB/scored/blob/master/LICENSE">LICENSE</a> for more details.