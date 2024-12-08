defmodule VirgilErp.Repo do
  use Ecto.Repo,
    otp_app: :virgil_erp,
    adapter: Ecto.Adapters.Postgres
end
