defmodule FidelityAppWeb.AdminLive do
  use FidelityAppWeb, :live_view
  # use Phoenix.LiveView


  def render(assigns) do
    ~L"""
    <h1>Admin Dashboard</h1>
    <div id=admin">
      <div class="sidebar"
        <nav>
          <a href="users">Users</a>
        </nav>
      </div>
      <div class="main">
        <div class="wrapper">
          <div class="card">
            <div class="header">
               <h1>Edit User</h1>
            </div>
            <div class="body">

            </div>
            <div class="footer"<

            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

end
