defmodule FrancisSite do
  use Francis, static: [at: "/", from: "priv/static"]

  import FrancisHtmx

  htmx(
    fn _ ->
      assigns = %{demos: demos(), deploy: deploy()}

      ~E"""
      <div class="p-20 font-mono z-10">
        <div class="bg-white rounded-xl p-4 shadow-xl flex flex-col gap-2">
          <div class="flex flex items-center">
            <img class="w-[2rem] h-auto" src="/icon.png">
            <h1 class="text-4xl text-bold"> Francis </h1>
          </div>
          <p class="text-2xl">DSL for your Elixir web application</p>
          <p> Documentation: <a href="https://hexdocs.pm/francis/readme.html" class="text-blue-500">hexdocs.pm/francis</a></p>
          <p class="text-md">To install it, add the following to your mix.exs:</p>
          <pre><code class="language-elixir text-md">{:francis, "~> 0.1.0"}</code></pre>
        </div>

        <div class="bg-white rounded-xl p-4 shadow-xl mt-5">
          <p>Deploy it with 2 commands</p>
          <pre><code class="language-bash text-md"><%= @deploy %></code></pre>
        </div>

        <div class="mt-5 grid lg:grid-cols-2 grid-cols-1 gap-2 justify-center items-center w-full">
          <%= for {title, demo} <- @demos do %>
          <div class="bg-white rounded-xl shadow-xl flex flex-col items-left h-[30rem] justify-center ">
            <h2 class="text-2xl text-bold text-center"><%= title %></h2>
              <pre><code class="language-elixir w-auto text-md"><%= demo %></code></pre>
          </div>
          <% end %>
        </div>


        <div class="bg-white rounded-xl p-4 shadow-xl mt-5">
          <p>It also enables you to build simple <a href="htmx.org" class="text-blue-500">htmx.org</a> websites with a small code footprint using <a href="https://github.com/filipecabaco/francis_htmx" class="text-blue-500">github.com/filipecabaco/francis_htmx</a></p>
          <p class="text-md">To install it in your project, add the following to your mix.exs:</p>
          <pre><code class="language-elixir">{:francis_htmx, "~> 0.1.0"}</code></pre>
        </div>

        <div class="bg-white rounded-xl p-4 shadow-xl mt-5">
          <p class="text-md">For more information and contribute, check out the repository at <a href="https://github.com/filipecabaco/francis" class="text-blue-500">github.com/filipecabaco/francis</a></p>
          <p class="text-md">Check the code for this website at <a href="https://github.com/filipecabaco/francis_site" class="text-blue-500">github.com/filipecabaco/francis_site</a></p>
        </div>
      </div>
      <div class="top-0 fixed pattern h-full w-full z-[-10]"></div>
      """
    end,
    title: "Francis - DSL for your Elixir web application",
    head: """
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/styles/github.min.css">
    <link href="/app.css" rel="stylesheet"></link>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/highlight.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/languages/elixir.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/11.9.0/languages/bash.min.js"></script>
    <script>hljs.highlightAll();</script>
    <!-- HTML Meta Tags -->

    <meta name="description" content="A lightweight DSL for building Elixir web applications with HTTP actions, WebSockets, static content serving, and more.">

    <!-- Facebook Meta Tags -->
    <meta property="og:url" content="https://francis.build">
    <meta property="og:type" content="website">
    <meta property="og:title" content="Francis - DSL for your Elixir web application">
    <meta property="og:description" content="A lightweight DSL for building Elixir web applications with HTTP actions, WebSockets, static content serving, and more.">
    <meta property="og:image" content="https://francis.build/ogp.png">
    <meta property="og:site_name" content="Francis">

    <!-- Twitter Meta Tags -->
    <meta name="twitter:card" content="summary_large_image">
    <meta property="twitter:domain" content="francis.build">
    <meta property="twitter:url" content="https://francis.build">
    <meta name="twitter:title" content="Francis - DSL for your Elixir web application">
    <meta name="twitter:description" content="A lightweight DSL for building Elixir web applications with HTTP actions, WebSockets, static content serving, and more.">
    <meta name="twitter:image" content="https://francis.build/ogp.png">

    <!-- Meta Tags Generated via https://www.opengraph.xyz -->
    """
  )

  defp deploy(),
    do: """
    mix francis.release
    fly launch
    """

  defp demos,
    do: [
      {"HTTP Actions",
       """
       defmodule GetJson do
          @moduledoc \"\"\"
          Handle Easily GET, POST, PUT and DELETE requests

          Automatically parse JSON body and params
          and responses with JSON
          \"\"\"

          use Francis

          get("/hello", fn _ -> %{hello: :world} end)
          get("/:name", fn %{params: params} -> params["name"] end)
          post("/", fn conn -> conn.body_params end)
       end
       """},
      {"Web Sockets",
       """
       defmodule WebSocket do
          @moduledoc \"\"\"
          Sets up a WebSocket endpoint
          and use pattern match to handle messages
          \"\"\"
          use Francis

          ws("ws", fn "ping", socket ->
            Process.send_after(socket.transport, "pong", 1000)
            {:reply, "pong"}
          end)
       end
       """},
      {"Static Content",
       """
       defmodule Static do
          @moduledoc \"\"\"
          Serve static files from a directory
          \"\"\"
          use Francis,
            static: [from: "pric/static", to: "/"]

          unmatched(fn _ -> "not found" end)
       end
       """},
      {"Error Handling",
       """
       defmodule NotFound do
          @moduledoc \"\"\"
          Simple not found handler setup
          \"\"\"
          use Francis

          unmatched(fn _ -> "not found" end)
       end
       """}
    ]
end
