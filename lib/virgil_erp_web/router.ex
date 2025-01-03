defmodule VirgilErpWeb.Router do
  use VirgilErpWeb, :router

  import VirgilErpWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {VirgilErpWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", VirgilErpWeb do
    pipe_through :browser

    get "/", PageController, :home

    live_session :current_user_pages,
      on_mount: [{VirgilErpWeb.UserAuth, :mount_current_user}] do
      live "/dashboard", DashboardLive, :index

      live "/projects", ProjectLive.Index, :index
      live "/projects/new", ProjectLive.Index, :new
      live "/projects/:id/edit", ProjectLive.Index, :edit

      live "/projects/:id", ProjectLive.Show, :show
      live "/projects/:id/show/edit", ProjectLive.Show, :edit

      live "/access_emails", AccessEmailLive.Index, :index
      live "/access_emails/new", AccessEmailLive.Index, :new
      live "/access_emails/:id/edit", AccessEmailLive.Index, :edit

      live "/access_emails/:id", AccessEmailLive.Show, :show
      live "/access_emails/:id/show/edit", AccessEmailLive.Show, :edit

      live "/project_tasks", ProjectTaskLive.Index, :index
      live "/project_tasks/new", ProjectTaskLive.Index, :new
      live "/project_tasks/:id/edit", ProjectTaskLive.Index, :edit

      live "/project_tasks/:id", ProjectTaskLive.Show, :show
      live "/project_tasks/:id/show/edit", ProjectTaskLive.Show, :edit

      live "/project_task_assignees", ProjectTaskAssigneeLive.Index, :index
      live "/project_task_assignees/new", ProjectTaskAssigneeLive.Index, :new
      live "/project_task_assignees/:id/edit", ProjectTaskAssigneeLive.Index, :edit

      live "/project_task_assignees/:id", ProjectTaskAssigneeLive.Show, :show
      live "/project_task_assignees/:id/show/edit", ProjectTaskAssigneeLive.Show, :edit

      live "/project_task_comments", ProjectTaskCommentLive.Index, :index
      live "/project_task_comments/new", ProjectTaskCommentLive.Index, :new
      live "/project_task_comments/:id/edit", ProjectTaskCommentLive.Index, :edit

      live "/project_task_comments/:id", ProjectTaskCommentLive.Show, :show
      live "/project_task_comments/:id/show/edit", ProjectTaskCommentLive.Show, :edit

      live "/client_contracts", ClientContractLive.Index, :index
      live "/client_contracts/new", ClientContractLive.Index, :new
      live "/client_contracts/:id/edit", ClientContractLive.Index, :edit

      live "/client_contracts/:id", ClientContractLive.Show, :show
      live "/client_contracts/:id/show/edit", ClientContractLive.Show, :edit
      live "/invoices", InvoiceLive.Index, :index
      live "/invoices/new", InvoiceLive.Index, :new
      live "/invoices/:id/edit", InvoiceLive.Index, :edit
      live "/invoices/:id", InvoiceLive.Show, :show
      live "/invoices/:id/show/edit", InvoiceLive.Show, :edit
      live "/revenues", RevenueLive.Index, :index
      live "/revenues/new", RevenueLive.Index, :new
      live "/revenues/:id/edit", RevenueLive.Index, :edit
      live "/revenues/:id", RevenueLive.Show, :show
      live "/revenues/:id/show/edit", RevenueLive.Show, :edit
      live "/expenses", ExpenseLive.Index, :index
      live "/expenses/new", ExpenseLive.Index, :new
      live "/expenses/:id/edit", ExpenseLive.Index, :edit
      live "/proposals", ProposalLive.Index, :index
      live "/proposals/new", ProposalLive.Index, :new
      live "/proposals/:id/edit", ProposalLive.Index, :edit
      live "/todos", TodoLive.Index, :index
      live "/todos/:id/edit", TodoLive.Index, :edit
    end
  end

  # Other scopes may use custom stacks.
  # scope "/api", VirgilErpWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:virgil_erp, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: VirgilErpWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", VirgilErpWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{VirgilErpWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/register", UserRegistrationLive, :new
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", VirgilErpWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{VirgilErpWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email
    end
  end

  scope "/", VirgilErpWeb do
    pipe_through [:browser]

    delete "/users/log_out", UserSessionController, :delete

    live_session :current_user,
      on_mount: [{VirgilErpWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end
